import 'package:equatable/equatable.dart';
import 'package:remote_control_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:remote_control_app/core/usecases/usecases.dart';
import 'package:remote_control_app/feature/control_panel/domain/repositories/data_stream_repository.dart';

class SetIpCase extends UseCase<void, SetIpParams> {
  final DataStreamRepository dataStreamRepository;

  SetIpCase(this.dataStreamRepository);

  @override
  Future<Either<Failure, void>> call(SetIpParams params) async {
    return await dataStreamRepository.setIpData(params.ipData);
  }
}

class SetIpParams extends Equatable {
  final String ipData;

  const SetIpParams({required this.ipData});

  @override
  List<Object> get props => [ipData];
}
