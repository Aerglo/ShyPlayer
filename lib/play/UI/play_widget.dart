import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shy_player/play/cubit/play_cubit.dart';

Widget playPage(BuildContext context, SongModel songModel) {
  return Center(
    child: Column(
      children: [
        BlocBuilder<PlayCubit, PlayState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case MusicChangedState:
                MusicChangedState newState = state as MusicChangedState;
                return artwork(newState.songModel, context);
              default:
                return artwork(songModel, context);
            }
          },
          buildWhen: (previous, current) => current is MusicChangedState,
        ),
        const Expanded(child: SizedBox()),
        Expanded(
          child: BlocBuilder<PlayCubit, PlayState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case MusicChangedState:
                  MusicChangedState newState = state as MusicChangedState;
                  return titleAndArtistBar(context, newState.songModel);
                default:
                  return titleAndArtistBar(context, songModel);
              }
            },
            buildWhen: (previous, current) => current is MusicChangedState,
          ),
        ),
        const Expanded(child: SizedBox()),
        Expanded(
          child: BlocBuilder<PlayCubit, PlayState>(
            builder: (context, state) {
              return actionBar(context);
            },
          ),
        ),
        const Expanded(child: SizedBox()),
        Expanded(
          child: BlocBuilder<PlayCubit, PlayState>(
            builder: (context, state) {
              return progressBar(context);
            },
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    ),
  );
}

Widget artwork(SongModel songModel, BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  return Stack(
    children: [
      Center(
        child: QueryArtworkWidget(
          id: songModel.id,
          type: ArtworkType.AUDIO,
          size: 500,
          quality: 100,
          artworkBorder: BorderRadius.circular(size.width * 0.8),
          format: ArtworkFormat.PNG,
          artworkHeight: size.width * 0.8,
          artworkWidth: size.width * 0.8,
          nullArtworkWidget: Container(
            height: size.width * 0.8,
            width: size.width * 0.8,
            decoration: BoxDecoration(
              color: colorScheme.onBackground,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
      Positioned(
        top: size.width * 0.3,
        left: size.width * 0.4,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            height: size.width * 0.2,
            width: size.width * 0.2,
            decoration: BoxDecoration(
              color: colorScheme.background.withOpacity(1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget titleAndArtistBar(BuildContext context, SongModel songModel) {
  Size size = MediaQuery.sizeOf(context);
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  return SizedBox(
    width: size.width * 0.8,
    child: Column(
      children: [
        Text(
          songModel.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '- ${songModel.artist} -' ?? '- Unknown Artist -',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.secondary,
            fontSize: 12,

          ),
        ),
      ],
    ),
  );
}

Widget repeatWidget(BuildContext context) {
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  if (BlocProvider.of<PlayCubit>(context).mode == LoopMode.off) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: BlocProvider.of<PlayCubit>(context).changeLoopMode,
        icon: Icon(
          Icons.repeat_rounded,
          color: colorScheme.secondary,
          size: 25,
        ),
      ),
    );
  } else if (BlocProvider.of<PlayCubit>(context).mode == LoopMode.all) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: BlocProvider.of<PlayCubit>(context).changeLoopMode,
        icon: Icon(
          Icons.repeat_rounded,
          color: colorScheme.primary,
          size: 25,
        ),
      ),
    );
  } else {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: BlocProvider.of<PlayCubit>(context).changeLoopMode,
        icon: Icon(
          Icons.repeat_one_rounded,
          color: colorScheme.primary,
          size: 25,
        ),
      ),
    );
  }
}

Widget actionBar(BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  return SizedBox(
    width: size.width * 0.8,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            shape: BoxShape.circle,
          ),
          child: InkResponse(
            onTap: BlocProvider.of<PlayCubit>(context).seekToStart,
            onDoubleTap: BlocProvider.of<PlayCubit>(context).seekToPreviousSong,
            child: Icon(
              Icons.skip_previous_rounded,
              color: colorScheme.secondary,
              size: 20,
            ),
          ),
        ),
        repeatWidget(context),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            shape: BoxShape.circle,
          ),
          child: InkResponse(
            onTap: BlocProvider.of<PlayCubit>(context).pauseAndPlay,
            child: Icon(
              BlocProvider.of<PlayCubit>(context).audioPlayer.playing
                  ? Icons.pause
                  : Icons.play_arrow_rounded,
              color: colorScheme.secondary,
              size: 30,
            ),
          ),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: BlocProvider.of<PlayCubit>(context).changeShuffle,
            icon: Icon(
              Icons.shuffle_rounded,
              color: BlocProvider.of<PlayCubit>(context).isShuffled
                  ? colorScheme.primary
                  : colorScheme.secondary,
              size: 25,
            ),
          ),
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            shape: BoxShape.circle,
          ),
          child: InkResponse(
            onTap: BlocProvider.of<PlayCubit>(context).seekToNextSong,
            child: Icon(
              Icons.skip_next_rounded,
              color: colorScheme.secondary,
              size: 20,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget progressBar(BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  return SizedBox(
    width: size.width * 0.8,
    child: ProgressBar(
      progress: BlocProvider.of<PlayCubit>(context).progress,
      total: BlocProvider.of<PlayCubit>(context).total,
      onSeek: (value) {
        BlocProvider.of<PlayCubit>(context).seekDuration(value);
      },
      baseBarColor: colorScheme.secondary,
      progressBarColor: colorScheme.primary,
      thumbRadius: 8,
      timeLabelTextStyle: TextStyle(
        color: colorScheme.secondary,
      ),
    ),
  );
}
