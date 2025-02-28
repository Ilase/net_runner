import 'package:json_annotation/json_annotation.dart';
import 'package:net_runner/core/domain/api/models/group/group_serial.dart';

part 'host_serial.g.dart';

@JsonSerializable()
class ModelHost {
  String name;
  String description;
  String ip;
  List<ModelGroup>? group_hosts;
  ModelHostInventory? inventory;

  ModelHost({
    required this.ip,
    required this.description,
    required this.group_hosts,
    required this.name,
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
  String full_os_version;
  int ram;
  int cpu_cores;
  String cpu_name;
  int uptime;

  ModelHostInventory({
    required this.name,
    required this.os,
    required this.kernel_version,
    required this.os_version,
    required this.full_os_version,
    required this.ram,
    required this.cpu_cores,
    required this.cpu_name,
    required this.uptime,
  });

  factory ModelHostInventory.fromJson(Map<String, dynamic> json) =>
      _$ModelHostInventoryFromJson(json);
  Map<String, dynamic> toJson() => _$ModelHostInventoryToJson(this);
}
