import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control_app/core/init/lang/locale_keys.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_bloc.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_event.dart';
import 'package:remote_control_app/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/init/logging/logger.dart';
import '../../../../core/init/navigation/navigation_service.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              logger.info('To qr scanner button pressed');
              sl<NavigationService>().navigateToPage(
                path: NavigationConstants.qrScanner,
              );
            },
            child: Text(
              LocaleKeys.firstMenuButton.tr(),
              style: TextStyle(fontSize: 40),
            )),
      ),
    ));
  }
}
