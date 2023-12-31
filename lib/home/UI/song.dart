import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shy_player/home/UI/home_widgets.dart';
import 'package:shy_player/play/UI/play.dart';
import 'package:shy_player/play/cubit/play_cubit.dart';

class Song extends StatelessWidget {
  const Song({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayCubit, PlayState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case NavigateToPlayPageState:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Play(),
              ),
            );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case PlayFetchLoadingState:
            return loadingWidget(context);
          case PlayFetchFailedState:
            return errorWidget(context);
          case PlayFetchSucceedState:
            PlayFetchSucceedState newState = state as PlayFetchSucceedState;
            return Column(
              children: [
                Expanded(
                  flex: 8,
                  child: songListWidget(context, newState.songList),
                ),
                Expanded(flex: 1, child: playingTile(context)),
              ],
            );
          case DurationChangedState:
            List<SongModel> songList =
                BlocProvider.of<PlayCubit>(context).songList;
            return Column(
              children: [
                Expanded(
                  flex: 8,
                  child: songListWidget(context, songList),
                ),
                Expanded(flex: 1, child: playingTile(context)),
              ],
            );
          case MusicChangedState:
            List<SongModel> songList =
                BlocProvider.of<PlayCubit>(context).songList;
            return Column(
              children: [
                Expanded(
                  flex: 8,
                  child: songListWidget(context, songList),
                ),
                Expanded(flex: 1, child: playingTile(context)),
              ],
            );
          case PlayPauseState:
            List<SongModel> songList =
                BlocProvider.of<PlayCubit>(context).songList;
            return Column(
              children: [
                Expanded(
                  flex: 8,
                  child: songListWidget(context, songList),
                ),
                Expanded(flex: 1, child: playingTile(context)),
              ],
            );
          default:
            return const Text(
              'Hello',
              style: TextStyle(color: Colors.red),
            );
        }
      },
      listenWhen: (previous, current) => current is PlayActionState,
      buildWhen: (previous, current) {
        if (current is PlayActionState) {
          return false;
        } else {
          if (current is DurationChangedState) {
            return false;
          }
        }
        return true;
      },
    );
  }
}
