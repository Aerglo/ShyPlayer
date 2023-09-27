import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        Expanded(
          child: BlocBuilder<PlayCubit, PlayState>(
            builder: (context, state) {
              return playPauseBar(context);
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
  return QueryArtworkWidget(
    id: songModel.id,
    type: ArtworkType.AUDIO,
    size: 500,
    quality: 100,
    format: ArtworkFormat.PNG,
    artworkHeight: size.width * 0.8,
    artworkWidth: size.width * 0.8,
    nullArtworkWidget: Container(
      height: size.width * 0.8,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: colorScheme.onBackground,
      ),
      child: Icon(
        Icons.music_note,
        color: colorScheme.secondary,
      ),
    ),
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
        const SizedBox(height: 10),
        Text(
          songModel.artist ?? 'Unknown Artist',
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

Widget actionBar(BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  return SizedBox(
    width: size.width * 0.8,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite_border,
            color: colorScheme.secondary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.repeat_rounded,
            color: colorScheme.secondary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.shuffle_rounded,
            color: colorScheme.secondary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add,
            color: colorScheme.secondary,
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

Widget playPauseBar(BuildContext context) {
  Size size = MediaQuery.sizeOf(context);
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  return SizedBox(
    width: size.width * 0.8,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkResponse(
          onTap: BlocProvider.of<PlayCubit>(context).seekToStart,
          onDoubleTap: BlocProvider.of<PlayCubit>(context).seekToPreviousSong,
          child: Icon(
            Icons.skip_previous_rounded,
            color: colorScheme.secondary,
          ),
        ),
        InkResponse(
          onTap: BlocProvider.of<PlayCubit>(context).pauseAndPlay,
          child: Icon(
            BlocProvider.of<PlayCubit>(context).audioPlayer.playing
                ? Icons.pause
                : Icons.play_arrow_rounded,
            color: colorScheme.secondary,
          ),
        ),
        InkResponse(
          onTap: BlocProvider.of<PlayCubit>(context).seekToNextSong,
          child: Icon(
            Icons.skip_next_rounded,
            color: colorScheme.secondary,
          ),
        ),
      ],
    ),
  );
}
