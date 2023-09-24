part of 'permission_cubit.dart';

@immutable
sealed class PermissionState {}

final class PermissionInitial extends PermissionState {}

class PermissionActionState extends PermissionState {}

class NavigateToHomePageState extends PermissionActionState {}

class ShowPermissionDeniedMessageState extends PermissionState {}

class PermissionPageLoadingState extends PermissionState {}
