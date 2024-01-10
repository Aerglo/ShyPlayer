import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  AlbumModel albumModel;
  List<SongModel> songList;

  AlbumCubit({required this.albumModel, required this.songList})
      : super(AlbumInitial());
}
