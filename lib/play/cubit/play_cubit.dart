import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'play_state.dart';

class PlayCubit extends Cubit<PlayState> {
  List<SongModel> songList = [];
  List<ArtistModel> artistList = [];
  List<PlaylistModel> playlistList = [];
  List<AlbumModel> albumList = [];
  SongModel? songModel;
  int index = -1;
  AudioPlayer audioPlayer;
  Widget? artwork;
  Duration progress = Duration.zero;
  Duration total = Duration.zero;
  Size size = Size(100, 100);
  late ColorScheme colorScheme;
  PlayCubit({required this.audioPlayer}) : super(PlayInitial());
  void initialFetch() async {
    emit(PlayFetchLoadingState());
    OnAudioQuery onAudioQuery = OnAudioQuery();

    try {
      songList = await onAudioQuery.querySongs();
      artistList = await onAudioQuery.queryArtists();
      playlistList = await onAudioQuery.queryPlaylists();
      albumList = await onAudioQuery.queryAlbums();
    } catch (e) {
      emit(PlayFetchFailedState());
      return;
    }
    emit(PlayFetchSucceedState(
      songList: songList,
      playlistList: playlistList,
      albumList: albumList,
      artistList: artistList,
    ));
  }

  void musicTileTapped(
    SongModel songModel,
    int index,
    List<SongModel> songList,
    BuildContext context,
  ) async {
    this.songModel = songModel;
    emit(PlayFetchSucceedState(
      songList: songList,
      playlistList: playlistList,
      albumList: albumList,
      artistList: artistList,
    ));
    List<AudioSource> sources = getAllSources(songList);
    final ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
      children: sources,
    );
    await audioPlayer.setAudioSource(
      playlist,
      initialIndex: index,
      initialPosition: Duration.zero,
    );
    audioPlayer.play();

    audioPlayer.positionStream.listen((event) {
      progress = event;
      emit(MusicChangedState());
    });
    audioPlayer.durationStream.listen((event) {
      total = event ?? Duration.zero;
      emit(MusicChangedState());
    });
    audioPlayer.currentIndexStream.listen((event) {
      this.index = event ?? -1;
      songModel = songList[this.index];
      artwork = getArtwork(size, colorScheme);
      emit(CurrentMusicChangedState());
    });

    if (context.mounted) {
      size = MediaQuery.sizeOf(context);
      colorScheme = Theme.of(context).colorScheme;
      artwork = getArtwork(size, colorScheme);
    }
    emit(NavigateToPlayPageState());
  }

  void pauseAndPlay() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    emit(MusicChangedState());
  }

  void seekDuration(Duration position) {
    audioPlayer.seek(position);
  }

  Widget getArtwork(Size size, ColorScheme colorScheme) {
    if (songModel != null) {
      return QueryArtworkWidget(
        id: songModel!.id,
        type: ArtworkType.AUDIO,
        size: 500,
        quality: 100,
        format: ArtworkFormat.PNG,
        artworkHeight: size.width * 0.8,
        artworkWidth: size.width * 0.8,
        nullArtworkWidget: Container(
          height: size.width * 0.8,
          width: size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: colorScheme.onBackground,
          ),
          child: Icon(
            Icons.music_note,
            color: colorScheme.secondary,
          ),
        ),
      );
    } else {
      return Container(
        height: size.width * 0.8,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: colorScheme.onBackground,
        ),
        child: Icon(
          Icons.music_note,
          color: colorScheme.secondary,
        ),
      );
    }
  }
}

List<AudioSource> getAllSources(List<SongModel> songList) {
  List<AudioSource> uris = [];
  for (SongModel songModel in songList) {
    uris.add(AudioSource.uri(Uri.parse(songModel.uri!)));
  }
  return uris;
}
