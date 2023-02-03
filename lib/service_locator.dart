import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:http/http.dart' as http;
import 'package:remote_control_app/core/init/navigation/navigation_route.dart';
import 'package:remote_control_app/core/init/navigation/navigation_service.dart';
import 'package:remote_control_app/core/init/network/network_info.dart';
import 'package:remote_control_app/feature/control_panel/data/repositories/data_stream_repository_impl.dart';
import 'package:remote_control_app/feature/control_panel/data/source/data_stream_source.dart';
import 'package:remote_control_app/feature/control_panel/data/source/ip_data_local_source.dart';
import 'package:remote_control_app/feature/control_panel/domain/repositories/data_stream_repository.dart';
import 'package:remote_control_app/feature/control_panel/domain/usecases/request_current_shot.dart';
import 'package:remote_control_app/feature/control_panel/domain/usecases/set_ip.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_bloc.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/qr_scanner_bloc/qr_scanner_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerSingleton<NavigationService>(NavigationService());
  sl.registerSingleton<NavigationRoute>(NavigationRoute());

  sl.registerFactory(() => RequestShotBloc(requestShotCase: sl()));
  sl.registerFactory(() => QRScannerBloc(setIpCase: sl()));

  sl.registerLazySingleton(() => RequestShotCase(sl()));
  sl.registerLazySingleton(() => SetIpCase(sl()));

  sl.registerLazySingleton<DataStreamRepository>(() => DataStreamRepositoryImpl(
        dataStreamSource: sl(),
        ipDataSource: sl(),
        networkInfo: sl(),
      ));

  // sl.registerLazySingleton<DataStreamSource>(() => DataStreamSourceImpl(
  //       client: sl(),
  //     ));

  sl.registerLazySingleton<DataStreamSource>(() => TestDataStreamSourceImpl(
        client: sl(),
      ));
  sl.registerLazySingleton<IPDataSource>(() => IPDataSourceImpl(
        sharedPreferences: sl(),
      ));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(
        sl(),
      ));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
