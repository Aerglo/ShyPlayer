import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shy_player/home/UI/home_widgets.dart';
import 'package:shy_player/play/cubit/play_cubit.dart';

class Artist extends StatelessWidget {
  const Artist({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayCubit, PlayState>(
      listener: (context, state) {
        // TODO: implement listener
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
                    child: artistListWidget(context, newState.artistList)),
                Expanded(flex: 1, child: playingTile(context)),
              ],
            );
          case DurationChangedState:
            List<ArtistModel> artistList =
                BlocProvider.of<PlayCubit>(context).artistList;
            return Column(
              children: [
                Expanded(flex: 8, child: artistListWidget(context, artistList)),
                Expanded(flex: 1, child: playingTile(context)),
              ],
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
