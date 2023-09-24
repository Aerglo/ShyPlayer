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

class MusicChangedState extends PlayState {}

class NavigateToPlayPageState extends PlayActionState {}
