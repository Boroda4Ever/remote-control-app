import 'package:remote_control_app/feature/control_panel/domain/entities/bounding_box_entity.dart';

class BoundingBoxModel extends BoundingBoxEntity {
  BoundingBoxModel({
    required top,
    required left,
    required width,
    required height,
  }) : super(
          top: top,
          left: left,
          width: width,
          height: height,
        );

  factory BoundingBoxModel.fromJson(Map<String, dynamic> json) {
    return BoundingBoxModel(
      top: json['top'],
      left: json['left'],
      width: json['width'],
      height: json['height'],
    );
  }
}
