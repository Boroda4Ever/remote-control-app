import 'package:remote_control_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:remote_control_app/core/usecases/usecases.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';
import 'package:remote_control_app/feature/control_panel/domain/repositories/data_stream_repository.dart';

class RequestShotCase extends UseCase<ShotEntity, RequestCurrentShot> {
  final DataStreamRepository dataStreamRepository;

  RequestShotCase(this.dataStreamRepository);

  @override
  Future<Either<Failure, ShotEntity>> call(RequestCurrentShot params) async {
    return await dataStreamRepository.getCurrentShot();
  }
}

class RequestCurrentShot {}
