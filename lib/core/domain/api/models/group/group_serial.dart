import 'package:json_annotation/json_annotation.dart';
import 'package:net_runner/core/domain/api/models/host/host_serial.dart';

part 'group_serial.g.dart';

@JsonSerializable()
class ModelGroup {
  String name;
  String description;
  List<ModelHost> hosts;
  ModelGroup({
    required this.name,
    required this.description,
    required this.hosts,
  });
  factory ModelGroup.fromJson(Map<String, dynamic> json) =>
      _$ModelGroupFromJson(json);
  Map<String, dynamic> toJson() => _$ModelGroupToJson(this);
}
