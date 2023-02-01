import 'package:flutter/material.dart';

import 'person_entity.dart';

class ShotEntity {
  final Image image;
  final List<PersonEntity> people;
  final bool dataChanged;

  ShotEntity({
    required this.image,
    required this.people,
    required this.dataChanged,
  });
}
