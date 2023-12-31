import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'play_state.dart';

class PlayCubit extends Cubit<PlayState> {
  List<SongModel> songList = [];
  List<ArtistModel> artistList = [];
  List<PlaylistModel> playlistList = [];
  List<AlbumModel> albumList = [];
  LoopMode mode = LoopMode.off;
  bool isShuffled = false;
  SongModel? songModel;
  int index = -1;
  AudioPlayer audioPlayer;
  Widget? artwork;
  Duration progress = Duration.zero;
  Duration total = Duration.zero;
  PlayCubit({required this.audioPlayer}) : super(PlayInitial());
  double turns = 0.0;
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
    audioPlayer.play(

    );

    audioPlayer.positionStream.listen((event) {
      progress = event;
      turns += 1.0 / 360.0;
      emit(RotationState());
      emit(DurationChangedState());
    });
    audioPlayer.durationStream.listen((event) {
      total = event ?? Duration.zero;
      emit(DurationChangedState());
    });
    audioPlayer.currentIndexStream.listen((event) {
      this.index = event ?? -1;
      songModel = songList[this.index];
      emit(MusicChangedState(
        songModel: songModel,
      ));
    });

    emit(NavigateToPlayPageState());
  }

  void pauseAndPlay() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
      emit(PlayPauseState());
    } else {
      await audioPlayer.play();
      emit(PlayPauseState());
    }
    emit(PlayPauseState());
  }

  void seekDuration(Duration position) {
    audioPlayer.seek(position);
    emit(DurationChangedState());
  }

  void seekToStart() {
    audioPlayer.seek(Duration.zero);
    emit(PlayPauseState());
  }

  void seekToPreviousSong() async {
    songModel = songList[--index];
    await audioPlayer.seekToPrevious();
    emit(PlayPauseState());
  }

  void seekToNextSong() async {
    songModel = songList[++index];
    await audioPlayer.seekToNext();
    emit(PlayPauseState());
  }

  void changeLoopMode() {
    if (mode == LoopMode.off) {
      mode = LoopMode.all;
    } else if (mode == LoopMode.all) {
      mode = LoopMode.one;
    } else {
      mode = LoopMode.off;
    }
    audioPlayer.setLoopMode(mode);
    emit(DurationChangedState());
  }
  void deletePlaylist(int playlistId) async {
    OnAudioQuery onAudioQuery = OnAudioQuery();
    await onAudioQuery.removePlaylist(playlistId);
    emit(PlayFetchSucceedState(
      songList: songList,
      playlistList: playlistList,
      albumList: albumList,
      artistList: artistList,
    ));
  }
  void rotation(double turns) {
    turns += 1.0 / 8.0;
    emit(DurationChangedState());
  }
  void pop() {
    initialFetch();
    emit(PlayPopButtonTappedState());
    initialFetch();
  }

  void pushFromPlayingTile() {
    emit(NavigateToPlayPageState());
  }

  void changeShuffle() {
    isShuffled = !isShuffled;
    audioPlayer.setShuffleModeEnabled(isShuffled);

    emit(DurationChangedState());
  }
}

List<AudioSource> getAllSources(List<SongModel> songList) {
  List<AudioSource> uris = [];
  for (SongModel songModel in songList) {
    uris.add(AudioSource.uri(Uri.parse(songModel.uri!),tag: MediaItem(
      // Specify a unique ID for each media item:
      id: '${songModel.id}',
      // Metadata to display in the notification:
      album: songModel.album,
      title: songModel.title,
      artUri: Uri.parse(songModel.uri!),
    ),),);
  }
  return uris;
}
