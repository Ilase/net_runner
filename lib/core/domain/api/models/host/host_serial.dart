import 'package:json_annotation/json_annotation.dart';
import 'package:net_runner/core/domain/api/models/group/group_serial.dart';

part 'host_serial.g.dart';

@JsonSerializable()
class ModelHost {
  int ID;
  String name;
  String? description;
  String ip;
  int UpdatedAt;
  List<ModelGroup>? Groups;
  ModelHostInventory? inventory;

  ModelHost({
    required this.UpdatedAt,
    required this.ID,
    required this.ip,
    this.description,
    required this.name,
    required this.Groups,
    required this.inventory,
  });

  factory ModelHost.fromJson(Map<String, dynamic> json) =>
      _$ModelHostFromJson(json);
  Map<String, dynamic> toJson() => _$ModelHostToJson(this);
}

@JsonSerializable()
class ModelHostInventory {
  String name;
  String os;
  String kernel_version;
  String os_version;
  String full_os_name;
  int ram;
  int cpu_cores;
  String cpu_name;
  int uptime;

  ModelHostInventory({
    required this.name,
    required this.os,
    required this.kernel_version,
    required this.os_version,
    required this.full_os_name,
    required this.ram,
    required this.cpu_cores,
    required this.cpu_name,
    required this.uptime,
  });

  factory ModelHostInventory.fromJson(Map<String, dynamic> json) =>
      _$ModelHostInventoryFromJson(json);
  Map<String, dynamic> toJson() => _$ModelHostInventoryToJson(this);
}
