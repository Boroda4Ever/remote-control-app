import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';

abstract class RequestShotEvent {
  const RequestShotEvent();
}

class RequestShotClearLoadEvent extends RequestShotEvent {}

class RequestShotLoadWithDataEvent extends RequestShotEvent {
  final ShotEntity previousData;

  RequestShotLoadWithDataEvent({required this.previousData});
}
