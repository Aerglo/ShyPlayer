import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shy_player/splash/cubit/splash_cubit.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SplashCubit>(context).navigateToPermissionPage(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Shy Player',
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
