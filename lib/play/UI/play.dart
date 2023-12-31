import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shy_player/home/UI/home.dart';
import 'package:shy_player/home/cubit/home_cubit.dart';
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: BlocProvider.of<PlayCubit>(context).pop,
          icon: const Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: BlocListener<PlayCubit, PlayState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case PlayPopButtonTappedState:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => HomeCubit(),
                      child: const Home(),
                    );
                  },
                ),
              );
          }
        },
        child: playPage(
          context,
          BlocProvider.of<PlayCubit>(context).songModel!,
        ),
        listenWhen: (previous, current) => current is PlayActionState,
      ),
    );
  }
}
