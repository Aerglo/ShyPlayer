import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'artist_state.dart';

class ArtistCubit extends Cubit<ArtistState> {
  List<SongModel> songList;
  ArtistModel artistModel;

  ArtistCubit({required this.artistModel, required this.songList})
      : super(ArtistInitial());
}
