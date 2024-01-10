import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shy_player/album/UI/album.dart';
import 'package:shy_player/album/cubit/album_cubit.dart';
import 'package:shy_player/artist/UI/artist.dart';
import 'package:shy_player/artist/cubit/artist_cubit.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  int index = 0;

  HomeCubit() : super(HomeInitial());

  void changeIndex(int index) {
    this.index = index;
    emit(HomeBottomNavigationBarChangedState());
  }

  void changeTheme() async {
    emit(HomeLoadingState());
    Get.changeThemeMode(
      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
    );
    Future.delayed(const Duration(seconds: 2));
    emit(HomeThemeChanged());
  }

  void onAlbumTap(AlbumModel albumModel, BuildContext context) async {
    OnAudioQuery onAudioQuery = OnAudioQuery();
    List<SongModel> songList = await onAudioQuery.queryAudiosFrom(
        AudiosFromType.ALBUM_ID, albumModel.id);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) =>
            AlbumCubit(albumModel: albumModel, songList: songList),
        child: Album(),
      ),
    ));
  }

  void onArtistTap(ArtistModel artistModel, BuildContext context) async {
    OnAudioQuery onAudioQuery = OnAudioQuery();
    List<SongModel> songList = await onAudioQuery.queryAudiosFrom(
        AudiosFromType.ARTIST_ID, artistModel.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              ArtistCubit(artistModel: artistModel, songList: songList),
          child: Artist(),
        ),
      ),
    );
  }
}
