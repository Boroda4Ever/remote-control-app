import 'package:remote_control_app/feature/control_panel/domain/entities/ip_entity.dart/ip_entity.dart';

class IPDataModel extends IPDataEntity {
  IPDataModel({
    required data,
  }) : super(data: data);

  factory IPDataModel.fromString(String str) {
    return IPDataModel(
      data: str,
    );
  }
  factory IPDataModel.fromJson(Map<String, dynamic> json) {
    return IPDataModel(
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
    };
  }
}
