import 'package:remote_control_app/feature/control_panel/domain/entities/ip_entity.dart/ip_entity.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';

abstract class QRScannerEvent {
  const QRScannerEvent();
}

class QRScannerLoadEvent extends QRScannerEvent {
  final String data;

  QRScannerLoadEvent({required this.data});
}

class QRScannerCleaningDataEvent extends QRScannerEvent {}
