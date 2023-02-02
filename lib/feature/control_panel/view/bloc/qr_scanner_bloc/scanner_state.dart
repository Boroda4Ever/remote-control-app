import 'package:remote_control_app/feature/control_panel/domain/entities/ip_entity.dart/ip_entity.dart';

abstract class QRScannerState {
  const QRScannerState();
}

class QRScannerEmptyState extends QRScannerState {}

class QRScannerLoadingState extends QRScannerState {}

class QRScannerSuccessfullState extends QRScannerState {}

class QRScannerStateErrorState extends QRScannerState {
  final String message;
  const QRScannerStateErrorState({required this.message});
}
