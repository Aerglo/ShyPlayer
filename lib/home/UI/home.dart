import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shy_player/home/UI/album.dart';
import 'package:shy_player/home/UI/artist.dart';
import 'package:shy_player/home/UI/home_widgets.dart';
import 'package:shy_player/home/UI/song.dart';
import 'package:shy_player/home/cubit/home_cubit.dart';
import 'package:shy_player/play/cubit/play_cubit.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PlayCubit>(context).initialFetch();
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return Scaffold(
              backgroundColor: Get.isDarkMode
                  ? Theme.of(context).colorScheme.onBackground
                  : Theme.of(context).colorScheme.background,
              body: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          default:
            return Scaffold(
              appBar: homeAppBar(context),
              backgroundColor: Get.isDarkMode
                  ? Theme.of(context).colorScheme.onBackground
                  : Theme.of(context).colorScheme.background,
              body: IndexedStack(
                index: BlocProvider.of<HomeCubit>(context).index,
                children: const [
                  Song(),
                  Album(),
                  Artist(),
                ],
              ),
              bottomNavigationBar: homeBottomNavigationBar(context),
            );
        }
      },
    );
  }
}
