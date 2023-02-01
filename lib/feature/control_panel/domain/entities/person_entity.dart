import 'bounding_box_entity.dart';

class PersonEntity {
  final BoundingBoxEntity boundingBox;
  final int id;
  final bool target;

  PersonEntity({
    required this.boundingBox,
    required this.id,
    required this.target,
  });
}
