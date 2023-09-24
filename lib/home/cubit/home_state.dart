part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeBottomNavigationBarChangedState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeThemeChanged extends HomeState {}
