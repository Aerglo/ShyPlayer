import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shy_player/play/cubit/play_cubit.dart';

AppBar playPageAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Get.isDarkMode
        ? Theme.of(context).colorScheme.onBackground
        : Theme.of(context).colorScheme.background,
    elevation: 0,
    leading: IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.secondary,
      ),
    ),
  );
}

Widget artworkWidget(BuildContext context) {
  return BlocProvider.of<PlayCubit>(context).artwork!;
}

Widget titleAndArtist(BuildContext context) {
  PlayCubit playCubit = BlocProvider.of<PlayCubit>(context);
  return SizedBox(
    width: MediaQuery.sizeOf(context).width * 0.8,
    child: Column(
      children: [
        Text(
          playCubit.songModel!.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          playCubit.songModel!.artist ?? 'Unknown Artist',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

Widget actionBar(BuildContext context) {
  return SizedBox(
    width: MediaQuery.sizeOf(context).width * 0.8,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite_border,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.repeat_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.shuffle_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    ),
  );
}

Widget progressBar(BuildContext context) {
  return SizedBox(
    width: MediaQuery.sizeOf(context).width * 0.8,
    child: ProgressBar(
      progress: BlocProvider.of<PlayCubit>(context).progress,
      total: BlocProvider.of<PlayCubit>(context).total,
      thumbColor: Theme.of(context).colorScheme.primary,
      baseBarColor: Theme.of(context).colorScheme.secondary,
      progressBarColor: Theme.of(context).colorScheme.primary,
      thumbRadius: 8,
      timeLabelTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      onSeek: (value) {},
    ),
  );
}

Widget playPauseBar(BuildContext context) {
  PlayCubit playCubit = BlocProvider.of<PlayCubit>(context);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.skip_previous_rounded,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(
          playCubit.audioPlayer.playing
              ? Icons.pause
              : Icons.play_arrow_rounded,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.skip_next,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ],
  );
}
