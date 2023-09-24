import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(PermissionInitial());
  void checkPermission() async {
    emit(PermissionPageLoadingState());
    OnAudioQuery onAudioQuery = OnAudioQuery();
    bool result = await onAudioQuery.checkAndRequest();
    if (result) {
      emit(NavigateToHomePageState());
    } else {
      emit(ShowPermissionDeniedMessageState());
    }
  }
}
