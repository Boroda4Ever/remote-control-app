import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control_app/core/init/lang/language_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_bloc.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/qr_scanner_bloc/qr_scanner_bloc.dart';

import 'core/constants/app/app_constants.dart';
import 'core/init/logging/error_handler.dart';
import 'core/init/logging/logger.dart';
import 'core/init/navigation/navigation_route.dart';
import 'core/init/navigation/navigation_service.dart';
import 'package:remote_control_app/service_locator.dart' as di;
import 'service_locator.dart';

void main() async {
  await _init();
  runZonedGuarded(() {
    initLogger();
    logger.info('Start main');

    ErrorHandler.init();
    runApp(
      EasyLocalization(
          supportedLocales: LanguageManager.instance.supportedLocales,
          path: ApplicationConstants.langAssetPath,
          startLocale: LanguageManager.instance.ruLocale,
          child: const App()),
    );
  }, ErrorHandler.recordError);
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RequestShotBloc>(
          create: (context) => sl<RequestShotBloc>(),
        ),
        BlocProvider<QRScannerBloc>(
          create: (context) => sl<QRScannerBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Remote Control App',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        onGenerateRoute: sl<NavigationRoute>().generateRoute,
        navigatorKey: sl<NavigationService>().navigatorKey,
      ),
    );
  }
}
