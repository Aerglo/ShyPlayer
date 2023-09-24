import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shy_player/home/UI/home.dart';
import 'package:shy_player/home/cubit/home_cubit.dart';
import 'package:shy_player/permission/cubit/permission_cubit.dart';

class Permission extends StatelessWidget {
  const Permission({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PermissionCubit>(context).checkPermission();
    return BlocConsumer<PermissionCubit, PermissionState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case ShowPermissionDeniedMessageState:
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Center(
                child: Text(
                  'Permission denied',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            );

          default:
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
        }
      },
      listener: (context, state) {
        switch (state.runtimeType) {
          case NavigateToHomePageState:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BlocProvider(
                    create: (context) => HomeCubit(),
                    child: const Home(),
                  );
                },
              ),
            );
            break;
          default:
        }
      },
      listenWhen: (previous, current) => current is PermissionActionState,
      buildWhen: (previous, current) => current is! PermissionActionState,
    );
  }
}
