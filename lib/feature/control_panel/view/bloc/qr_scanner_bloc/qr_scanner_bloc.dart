import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control_app/core/error/failure.dart';
import 'package:remote_control_app/core/init/logging/logger.dart';
import 'package:remote_control_app/feature/control_panel/domain/usecases/set_ip.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/qr_scanner_bloc/scanner_event.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/qr_scanner_bloc/scanner_state.dart';

class QRScannerBloc extends Bloc<QRScannerEvent, QRScannerState> {
  final SetIpCase setIpCase;

  QRScannerBloc({required this.setIpCase}) : super(QRScannerEmptyState()) {
    on<QRScannerLoadEvent>(_onEventLoad);
    on<QRScannerCleaningDataEvent>(_onClear);
  }

  FutureOr<void> _onClear(
      QRScannerCleaningDataEvent event, Emitter<QRScannerState> emit) async {
    emit(QRScannerEmptyState());
  }

  FutureOr<void> _onEventLoad(
      QRScannerLoadEvent event, Emitter<QRScannerState> emit) async {
    emit(QRScannerLoadingState());
    final failureOrSuccess = await setIpCase(SetIpParams(ipData: event.data));
    emit(failureOrSuccess.fold(
        (failure) =>
            QRScannerStateErrorState(message: _mapFailureToMessage(failure)),
        (success) => QRScannerSuccessfullState()));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case InvalidIpFailure:
        return "Неправильный qr код";
      default:
        return 'Unexpected Error';
    }
  }
}
