import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control_app/core/init/lang/locale_keys.dart';
import 'package:remote_control_app/core/init/logging/logger.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/person_entity.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/request_bloc.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/request_state.dart';
import 'package:remote_control_app/feature/control_panel/view/widgets/workspaceWidget.dart';

import '../bloc/request_event.dart';

class ControlPanelPage extends StatefulWidget {
  const ControlPanelPage({super.key});

  @override
  State<ControlPanelPage> createState() => _ControlPanelPageState();
}

class _ControlPanelPageState extends State<ControlPanelPage> {
  Image? tempImage;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          endDrawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  child: Text(LocaleKeys.drawerHeader.tr()),
                ),
                ListTile(title: Text("data")),
                ListTile(title: Text("data")),
                ListTile(title: Text("data")),
              ],
            ),
          ),
          body: BlocBuilder<RequestShotBloc, RequestShotState>(
              builder: (context, state) {
            return Stack(
              children: [tempImage ?? SizedBox(), drawUI(state)],
            );
          }),
        ),
      ),
      onWillPop: () async {
        logger.info('On Control Panel back button pressed');
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        return true;
      },
    );
  }

  Widget drawUI(RequestShotState state) {
    if (state is RequestShotLoadedState) {
      _getDataCycle(state.data);
      return Workspace(
        data: state.data,
      );
    } else if (state is RequestShotLoadingWithPreviousDataState) {
      tempImage = state.previousData.image;
      return Workspace(
        data: state.previousData,
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Future<void> _getDataCycle(ShotEntity previousData) async {
    Future.delayed(
        Duration(seconds: 2),
        () => BlocProvider.of<RequestShotBloc>(context)
            .add(RequestShotLoadWithDataEvent(previousData: previousData)));
  }
}
