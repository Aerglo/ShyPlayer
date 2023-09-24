import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shy_player/play/UI/play_widget.dart';
import 'package:shy_player/play/cubit/play_cubit.dart';

class Play extends StatelessWidget {
  const Play({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Theme.of(context).colorScheme.onBackground
          : Theme.of(context).colorScheme.background,
      appBar: playPageAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocProvider.of<PlayCubit>(context).artwork!,
            titleAndArtist(context),
            actionBar(context),
            progressBar(context),
            playPauseBar(context),
          ],
        ),
      ),
    );
  }
}
