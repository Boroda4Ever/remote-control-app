import 'package:remote_control_app/core/error/exeption.dart';
import 'package:remote_control_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:remote_control_app/core/init/logging/logger.dart';
import 'package:remote_control_app/core/init/network/network_info.dart';
import 'package:remote_control_app/feature/control_panel/data/models/shot_models/shot_model.dart';
import 'package:remote_control_app/feature/control_panel/data/source/ip_data_local_source.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';
import 'package:remote_control_app/feature/control_panel/domain/repositories/data_stream_repository.dart';

import '../source/data_stream_source.dart';

class DataStreamRepositoryImpl extends DataStreamRepository {
  final DataStreamSource dataStreamSource;
  final IPDataSource ipDataSource;
  final NetworkInfo networkInfo;

  DataStreamRepositoryImpl({
    required this.dataStreamSource,
    required this.ipDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ShotEntity>> getCurrentShot() async {
    logger.info("(Data repository)Request shot");
    final ipData = await ipDataSource.getIPFromCache();
    return await _getData(() {
      return dataStreamSource.getCurrentShot(ipData.data);
    });
  }

  @override
  Future<Either<Failure, void>> setIpData(String ipData) async {
    return await _setIpData(() {
      return ipDataSource.ipToCache(ipData);
    });
  }

  Future<Either<Failure, void>> _setIpData(
      Future<void> Function() setData) async {
    try {
      final setDataResult = await setData();
      return Right(setDataResult);
    } on CacheException {
      logger.info('Cache Exception');
      return Left(CacheFailure());
    } on InvalidIpException {
      logger.info('Format Exception');
      return Left(InvalidIpFailure());
    }
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
