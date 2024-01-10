import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shy_player/play/cubit/play_cubit.dart';
import 'package:shy_player/splash/UI/splash.dart';
import 'package:shy_player/splash/cubit/splash_cubit.dart';
import 'package:shy_player/themes/dark_theme.dart';
import 'package:shy_player/themes/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlayCubit(
        audioPlayer: AudioPlayer(),
      ),
      child: GetMaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (context) => SplashCubit(),
          child: const Splash(),
        ),
      ),
    );
  }
}
