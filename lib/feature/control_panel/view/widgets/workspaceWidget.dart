import 'package:flutter/material.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';

import 'boundingBoxLayerWidget.dart';
import 'controlLayerWidget.dart';
import 'imageLayerWidget.dart';

class Workspace extends StatelessWidget {
  final ShotEntity data;
  const Workspace({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        ImageLayer(
          imageData: data.image,
        ),
        BoundingBoxesLayer(
          peopleData: data.people,
        ),
        ControlLayer(),
      ],
    );
  }
}
