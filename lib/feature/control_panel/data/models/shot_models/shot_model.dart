import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:remote_control_app/feature/control_panel/domain/entities/shot_entity.dart';

import 'person_model.dart';

class ShotModel extends ShotEntity {
  ShotModel({
    required image,
    required people,
    required dataChanged,
  }) : super(image: image, people: people, dataChanged: dataChanged);

  factory ShotModel.fromJson(Map<String, dynamic> json) {
    List<PersonModel> people = [];
    if (json['people'] != null) {
      json['people'].forEach((v) {
        people.add(PersonModel.fromJson(v));
      });
    }
    return ShotModel(
        image: Image.memory(
          base64Decode(json['image']),
          fit: BoxFit.fitWidth,
          height: double.infinity,
          width: double.infinity,
        ),
        people: people,
        dataChanged: json['data_changed']);
  }
}
