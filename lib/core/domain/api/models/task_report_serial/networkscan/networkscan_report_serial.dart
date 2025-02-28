import 'package:json_annotation/json_annotation.dart';
import 'package:net_runner/core/domain/api/models/task_report_serial/general_info.dart';

part 'networkscan_report_serial.g.dart';

@JsonSerializable()
class NetworkScanReport {
  GeneralInfo generalInfo;
  List<NetworkScanHost> hosts;

  NetworkScanReport({
    required this.generalInfo,
    required this.hosts,
  });

  factory NetworkScanReport.fromJson(Map<String, dynamic> json) =>
      _$NetworkScanReportFromJson(json);
  Map<String, dynamic> toJson() => _$NetworkScanReportToJson(this);
}

@JsonSerializable()
class NetworkScanHost {
  String ip;
  String mac;
  String os;
  String cpe;
  NetworkScanHost({
    required this.ip,
    required this.cpe,
    required this.mac,
    required this.os,
  });

  factory NetworkScanHost.fromJson(Map<String, dynamic> json) =>
      _$NetworkScanHostFromJson(json);
  Map<String, dynamic> toJson() => _$NetworkScanHostToJson(this);
}
