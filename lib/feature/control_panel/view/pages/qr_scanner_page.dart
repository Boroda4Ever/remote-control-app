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
            //_showOtherSnackBar();
            BlocProvider.of<RequestShotBloc>(context)
                .add(RequestShotClearLoadEvent());
            sl<NavigationService>().navigateToPage(
              path: NavigationConstants.controlPanel,
            );
          }
        },
        child: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (result != null)
                      Text(
                          'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                    else
                      const Text('Scan a code'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Text('Flash: ${snapshot.data}');
                                },
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                              onPressed: () async {
                                await controller?.flipCamera();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getCameraInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                        'Camera facing ${describeEnum(snapshot.data!)}');
                                  } else {
                                    return const Text('loading');
                                  }
                                },
                              )),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller?.pauseCamera();
                            },
                            child: const Text('pause',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller?.resumeCamera();
                            },
                            child: const Text('resume',
                                style: TextStyle(fontSize: 20)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
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
                  child: Center(child: Text("Ошибка получения данных"))),
            ));
    controller?.resumeCamera();
    BlocProvider.of<QRScannerBloc>(context).add(QRScannerCleaningDataEvent());
  }

  void _showOtherSnackBar() async {
    controller?.pauseCamera();
    await showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              content: SizedBox(
                  height: 100,
                  width: 200,
                  child: Center(child: Text("Vse norm"))),
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
        result = scanData;
        logger.info('result: ${result!.code}');
        BlocProvider.of<QRScannerBloc>(context)
            .add(QRScannerLoadEvent(data: result!.code!));
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
