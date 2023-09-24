import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  int index = 0;
  HomeCubit() : super(HomeInitial());
  void changeIndex(int index) {
    this.index = index;
    emit(HomeBottomNavigationBarChangedState());
  }

  void changeTheme() async {
    emit(HomeLoadingState());
    Get.changeThemeMode(
      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
    );
    Future.delayed(const Duration(seconds: 2));
    emit(HomeThemeChanged());
  }
}
