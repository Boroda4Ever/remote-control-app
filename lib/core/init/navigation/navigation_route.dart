import 'package:flutter/material.dart';

import '../../../common/architecture_widgets/not_found_navigation_widget.dart';
import '../../../feature/control_panel/view/pages/control_panel_page.dart';
import '../../../feature/menu/view/pages/menu_page.dart';
import '../../../feature/qr_scanner/view/pages/qr_scanner_page.dart';
import '../../constants/navigation/navigation_constants.dart';

class NavigationRoute {
  NavigationRoute();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationConstants.defaultRoute:
        return normalNavigate(const MenuPage(),
            NavigationConstants.defaultRoute, settings.arguments);

      case NavigationConstants.menu:
        return normalNavigate(
            const MenuPage(), NavigationConstants.menu, settings.arguments);

      case NavigationConstants.qrScanner:
        return normalNavigate(const QRScannerPage(),
            NavigationConstants.qrScanner, settings.arguments);

      case NavigationConstants.controlPanel:
        return normalNavigate(const ControlPanelPage(),
            NavigationConstants.controlPanel, settings.arguments);
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundNavigationWidget(),
        );
    }
  }

  MaterialPageRoute normalNavigate(
      Widget widget, String pageName, Object? args) {
    return MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(name: pageName, arguments: args));
  }
}
