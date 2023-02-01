import 'package:remote_control_app/core/error/exeption.dart';
import 'package:remote_control_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:remote_control_app/core/init/logging/logger.dart';
import 'package:remote_control_app/core/init/network/network_info.dart';
import 'package:remote_control_app/feature/control_panel/data/models/shot_model.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';
import 'package:remote_control_app/feature/control_panel/domain/repositories/data_stream_repository.dart';

import '../source/data_stream_source.dart';

class DataStreamRepositoryImpl extends DataStreamRepository {
  final DataStreamSource remoteDataSource;
  final NetworkInfo networkInfo;

  DataStreamRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ShotEntity>> getCurrentShot() async {
    return await _getData(() {
      return remoteDataSource.getCurrentShot();
    });
  }

  Future<Either<Failure, ShotModel>> _getData(
      Future<ShotModel> Function() getData) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await getData();
        return Right(remoteData);
      } on ServerException {
        logger.info('Failed request');
        return Left(ServerFailure());
      }
    } else {
      logger.info('Network connaction fail');
      return Left(NetworkFailure());
    }
  }
}
