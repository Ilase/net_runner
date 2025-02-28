import 'package:json_annotation/json_annotation.dart';

part 'general_info.g.dart';

@JsonSerializable()
class GeneralInfo {
  String task_name;
  String task_number;
  String start;
  String end;
  String version;
  String elapsed;
  String summary;
  int up;
  int down;
  int total;

  GeneralInfo({
    required this.task_name,
    required this.task_number,
    required this.start,
    required this.end,
    required this.version,
    required this.elapsed,
    required this.summary,
    required this.up,
    required this.down,
    required this.total,
  });

  factory GeneralInfo.fromJson(Map<String, dynamic> json) =>
      _$GeneralInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralInfoToJson(this);
}
