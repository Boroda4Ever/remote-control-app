import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control_app/core/error/failure.dart';
import 'package:remote_control_app/feature/control_panel/domain/usecases/request_current_shot.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_event.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_state.dart';

class RequestShotBloc extends Bloc<RequestShotEvent, RequestShotState> {
  final RequestShotCase requestShotCase;

  RequestShotBloc({required this.requestShotCase})
      : super(RequestShotEmptyState()) {
    on<RequestShotClearLoadEvent>(_onEventClearLoad);
    on<RequestShotLoadWithDataEvent>(_onEventLoadWithData);
  }

  FutureOr<void> _onEventClearLoad(
      RequestShotClearLoadEvent event, Emitter<RequestShotState> emit) async {
    emit(RequestShotLoadingWithoutPreviousDataState());
    final failureOrData = await requestShotCase(RequestCurrentShot());
    emit(failureOrData.fold(
        (failure) =>
            RequestShotErrorState(message: _mapFailureToMessage(failure)),
        (data) => RequestShotLoadedState(data: data)));
  }

  FutureOr<void> _onEventLoadWithData(RequestShotLoadWithDataEvent event,
      Emitter<RequestShotState> emit) async {
    emit(RequestShotLoadingWithPreviousDataState(
        previousData: event.previousData));
    final failureOrData = await requestShotCase(RequestCurrentShot());
    emit(failureOrData.fold(
        (failure) =>
            RequestShotErrorState(message: _mapFailureToMessage(failure)),
        (data) => RequestShotLoadedState(data: data)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Ошибка сервера";
      case NetworkFailure:
        return "Ошибка сетевого соединения";
      default:
        return 'Unexpected Error';
    }
  }
}
