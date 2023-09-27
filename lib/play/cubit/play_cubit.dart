import 'dart:developer';

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
      emit(DurationChangedState());
    });
    audioPlayer.durationStream.listen((event) {
      total = event ?? Duration.zero;
      emit(DurationChangedState());
    });
    audioPlayer.currentIndexStream.listen((event) {
      this.index = event ?? -1;
      log(songModel.title);
      songModel = songList[this.index];
      log(songModel.title);
      emit(MusicChangedState(
        songModel: songModel,
      ));
    });

    emit(NavigateToPlayPageState());
  }

  void pauseAndPlay() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    emit(DurationChangedState());
  }

  void seekDuration(Duration position) {
    audioPlayer.seek(position);
    emit(DurationChangedState());
  }

  void seekToStart() {
    audioPlayer.seek(Duration.zero);
    emit(DurationChangedState());
  }

  void seekToPreviousSong() async {
    songModel = songList[--index];
    await audioPlayer.seekToPrevious();
    emit(DurationChangedState());
  }

  void seekToNextSong() async {
    songModel = songList[++index];
    await audioPlayer.seekToNext();
    emit(DurationChangedState());
  }
}

List<AudioSource> getAllSources(List<SongModel> songList) {
  List<AudioSource> uris = [];
  for (SongModel songModel in songList) {
    uris.add(AudioSource.uri(Uri.parse(songModel.uri!)));
  }
  return uris;
}
