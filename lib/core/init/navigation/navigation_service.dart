import 'package:flutter/material.dart';

import 'i_navigation_service.dart';

class NavigationService implements INavigationService {
  NavigationService();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  bool removeAllOldRoutes(Route<dynamic> route) => false;

  @override
  Future<void> navigateToPage({String? path, Object? data}) async {
    await navigatorKey.currentState!.pushNamed(path!, arguments: data);
  }

  @override
  Future<void> navigateToPageClear({String? path, Object? data}) async {
    await navigatorKey.currentState!
        .pushNamedAndRemoveUntil(path!, removeAllOldRoutes, arguments: data);
  }
}
