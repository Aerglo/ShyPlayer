import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shy_player/permission/UI/permission.dart';
import 'package:shy_player/permission/cubit/permission_cubit.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void navigateToPermissionPage(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return BlocProvider<PermissionCubit>(
              create: (context) => PermissionCubit(),
              child: const Permission(),
            );
          },
        ),
      );
    });
  }
}
