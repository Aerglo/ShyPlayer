import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shy_player/play/UI/play_widget.dart';
import 'package:shy_player/play/cubit/play_cubit.dart';

class Play extends StatelessWidget {
  const Play({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayCubit, PlayState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case NextIndexState:
            NextIndexState newState = state as NextIndexState;
            print('im here');
            return playPage(context, newState.songModel);
          default:
            return playPage(context, null);
        }
      },
      listener: (context, state) {
        switch (state.runtimeType) {
          case CurrentMusicChangedState:
            Navigator.of(context).pop;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Play(),
              ),
            );
        }
      },
      buildWhen: (previous, current) => current is! PlayActionState,
      listenWhen: (previous, current) => current is PlayActionState,
    );
  }
}
