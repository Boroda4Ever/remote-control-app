import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control_app/core/init/lang/locale_keys.dart';
import 'package:remote_control_app/core/init/logging/logger.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_bloc.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_event.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_state.dart';
import 'package:remote_control_app/feature/control_panel/view/widgets/workspaceWidget.dart';

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
            logger.info('rebuild');
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
    } else if (state is RequestShotErrorState) {
      return Center(
        child: Column(
          children: [
            Text(state.message),
            TextButton(
                onPressed: () {
                  BlocProvider.of<RequestShotBloc>(context)
                      .add(RequestShotClearLoadEvent());
                },
                child: Text("??????????????????????????????")),
          ],
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Future<void> _getDataCycle(ShotEntity previousData) async {
    logger.info('get new shot');
    Future.delayed(
        Duration(milliseconds: 20),
        () => BlocProvider.of<RequestShotBloc>(context)
            .add(RequestShotLoadWithDataEvent(previousData: previousData)));
  }
}
