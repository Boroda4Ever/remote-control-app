import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';

abstract class RequestShotState {
  const RequestShotState();
}

class RequestShotEmptyState extends RequestShotState {}

class RequestShotLoadingWithoutPreviousDataState extends RequestShotState {}

class RequestShotLoadingWithPreviousDataState extends RequestShotState {
  final ShotEntity previousData;
  const RequestShotLoadingWithPreviousDataState({required this.previousData});
}

class RequestShotLoadedState extends RequestShotState {
  final ShotEntity data;
  const RequestShotLoadedState({required this.data});
}

class RequestShotErrorState extends RequestShotState {
  final String message;
  const RequestShotErrorState({required this.message});
}
