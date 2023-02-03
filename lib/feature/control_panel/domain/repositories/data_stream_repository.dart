import 'package:dartz/dartz.dart';
import 'package:remote_control_app/core/error/failure.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';

abstract class DataStreamRepository {
  Future<Either<Failure, ShotEntity>> getCurrentShot();

  Future<Either<Failure, void>> setIpData(String ipData);
}
