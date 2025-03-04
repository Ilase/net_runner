import 'package:json_annotation/json_annotation.dart';

part 'task_serial.g.dart';

@JsonSerializable()
class ModelTask {
  int ID;
  String? CreatedAt;
  String? UpdatedAt;
  String number_task;
  int percent;
  String name;
  String type;
  String status;
  ModelPentestParams params;

  ModelTask({
    required this.ID,
    required this.CreatedAt,
    required this.UpdatedAt,
    required this.number_task,
    required this.percent,
    required this.name,
    required this.type,
    required this.status,
    required this.params,
  });
  factory ModelTask.fromJson(Map<String, dynamic> json) =>
      _$ModelTaskFromJson(json);
  Map<String, dynamic> toJson() => _$ModelTaskToJson(this);
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
