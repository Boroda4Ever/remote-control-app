import 'package:flutter/material.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/person_entity.dart';

class BoundingBoxesLayer extends StatelessWidget {
  final List<PersonEntity> peopleData;
  const BoundingBoxesLayer({super.key, required this.peopleData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...peopleData.map((e) => Positioned(
            top: e.boundingBox.top.toDouble(),
            left: e.boundingBox.left.toDouble(),
            child: Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'id:0',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
              height: e.boundingBox.height.toDouble(),
              width: e.boundingBox.width.toDouble(),
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.red)),
            )))
      ],
    );
  }
}
