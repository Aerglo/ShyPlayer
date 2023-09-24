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
  Duration total = Duration(seconds: 20);
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

  void musicTileTapped(SongModel songModel, int index, List<SongModel> songList,
      BuildContext context) {
    this.songModel = songModel;
    emit(PlayFetchSucceedState(
      songList: songList,
      playlistList: playlistList,
      albumList: albumList,
      artistList: artistList,
    ));
    emit(NavigateToPlayPageState());
    artwork = getArtwork(context);
  }

  Widget getArtwork(BuildContext context) {
    return QueryArtworkWidget(
      id: songModel!.id,
      type: ArtworkType.AUDIO,
      size: 500,
      quality: 100,
      format: ArtworkFormat.PNG,
      artworkHeight: MediaQuery.sizeOf(context).width * 0.8,
      artworkWidth: MediaQuery.sizeOf(context).width * 0.8,
      nullArtworkWidget: Container(
        height: MediaQuery.sizeOf(context).width * 0.8,
        width: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).colorScheme.onBackground,
        ),
        child: Icon(
          Icons.music_note,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
