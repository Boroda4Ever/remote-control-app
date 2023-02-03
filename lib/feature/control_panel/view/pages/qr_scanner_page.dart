import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:remote_control_app/core/constants/navigation/navigation_constants.dart';
import 'package:remote_control_app/core/init/logging/logger.dart';
import 'package:remote_control_app/core/init/navigation/navigation_service.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_bloc.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/control_panel_bloc/request_event.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/qr_scanner_bloc/qr_scanner_bloc.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/qr_scanner_bloc/scanner_event.dart';
import 'package:remote_control_app/feature/control_panel/view/bloc/qr_scanner_bloc/scanner_state.dart';
import 'package:remote_control_app/service_locator.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<QRScannerBloc, QRScannerState>(
        listener: (context, state) {
          if (state is QRScannerStateErrorState) {
            _showSnackBar(state.message);
          } else if (state is QRScannerSuccessfullState) {
            BlocProvider.of<RequestShotBloc>(context)
                .add(RequestShotClearLoadEvent());
            sl<NavigationService>().navigateToPage(
              path: NavigationConstants.controlPanel,
            );
            BlocProvider.of<QRScannerBloc>(context)
                .add(QRScannerCleaningDataEvent());
          }
        },
        child: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.grey,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _showSnackBar(String message) async {
    controller?.pauseCamera();
    await showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              content: SizedBox(
                  height: 100,
                  width: 200,
                  child: Center(child: Text("Неправильный QR код"))),
            ));
    controller?.resumeCamera();
    BlocProvider.of<QRScannerBloc>(context).add(QRScannerCleaningDataEvent());
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        controller?.pauseCamera();
        result = scanData;
        logger.info('result: ${result!.code}');
        logger.info('emit loading:');
        BlocProvider.of<QRScannerBloc>(context)
            .add(QRScannerLoadEvent(data: result!.code!));
        controller?.resumeCamera();
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
