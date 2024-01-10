part of 'play_cubit.dart';

@immutable
sealed class PlayState {}

final class PlayInitial extends PlayState {}

class PlayFetchLoadingState extends PlayState {}

class PlayActionState extends PlayState {}

class PlayFetchSucceedState extends PlayState {
  final List<SongModel> songList;
  final List<PlaylistModel> playlistList;
  final List<AlbumModel> albumList;
  final List<ArtistModel> artistList;
  PlayFetchSucceedState({
    required this.songList,
    required this.playlistList,
    required this.artistList,
    required this.albumList,
  });
}

class PlayFetchFailedState extends PlayState {}

class DurationChangedState extends PlayState {}

class NavigateToPlayPageState extends PlayActionState {}

class MusicChangedState extends PlayActionState {
  final SongModel songModel;
  MusicChangedState({
    required this.songModel,
  });
}

class PlayLoadingState extends PlayState {}

class PlayPopButtonTappedState extends PlayActionState {}

class PlayPauseState extends PlayState {}
