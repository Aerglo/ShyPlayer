import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shy_player/play/UI/play_widget.dart';
import 'package:shy_player/play/cubit/play_cubit.dart';

class Play extends StatelessWidget {
  const Play({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<PlayCubit, PlayState>(
        listener: (context, state) {
          switch (state.runtimeType) {}
        },
        child:
            playPage(context, BlocProvider.of<PlayCubit>(context).songModel!),
        listenWhen: (previous, current) => current is PlayActionState,
      ),
    );
  }
}
