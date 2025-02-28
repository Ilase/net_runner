import 'package:json_annotation/json_annotation.dart';

part 'task_serial.g.dart';

@JsonSerializable()
class ModelPentestTask {
  int ID;

  String CreatedAt;
  String UpdatedAt;
  String DeletedAt;
  String number_task;
  String name;
  String type;
  String status;
  ModelPentestParams params;

  ModelPentestTask({
    required this.ID,
    required this.CreatedAt,
    required this.UpdatedAt,
    required this.DeletedAt,
    required this.number_task,
    required this.name,
    required this.type,
    required this.status,
    required this.params,
  });
}

@JsonSerializable()
class ModelPentestParams {
  String networkAddress;
  String speed;
  ModelPentestParams({required this.networkAddress, required this.speed});

  factory ModelPentestParams.fromJson(Map<String, dynamic> json) =>
      _$ModelPentestParamsFromJson(json);
  Map<String, dynamic> toJson() => _$ModelPentestParamsToJson(this);
}

@JsonSerializable()
class ModelNetworkScanParams {
  String ports;
  String speed;
  ModelNetworkScanParams({required this.ports, required this.speed});

  factory ModelNetworkScanParams.fromJson(Map<String, dynamic> json) =>
      _$ModelNetworkScanParamsFromJson(json);
  Map<String, dynamic> toJson() => _$ModelNetworkScanParamsToJson(this);
}
