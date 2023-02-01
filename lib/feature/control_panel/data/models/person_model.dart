import 'package:remote_control_app/feature/control_panel/domain/entities/person_entity.dart';

import 'bounding_box_model.dart';

class PersonModel extends PersonEntity {
  PersonModel({
    required boundingBox,
    required id,
    required target,
  }) : super(
          boundingBox: boundingBox,
          id: id,
          target: target,
        );
  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      boundingBox: BoundingBoxModel.fromJson(json['bounding_box']),
      id: json['id'],
      target: json['target'],
    );
  }
}
