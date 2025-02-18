import 'package:json_annotation/json_annotation.dart';

part 'scan_responce.g.dart';

@JsonSerializable()
class ScanResult {
  // ignore: non_constant_identifier_names
  GeneralInfo general_info;
  Map<String, Host> hosts;
  Map<String, Diff> diff;

  ScanResult({
    required this.general_info,
    required this.hosts,
    required this.diff,
  });

  factory ScanResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ScanResult(
        general_info: GeneralInfo(
          task_name: 'ERROR',
          start: 'ERROR',
          end: 'ERROR',
          version: 'ERROR',
          elapsed: 'ERROR',
          summary: 'ERROR',
          up: 0,
          down: 0,
          total: 0,
        ),
        hosts: {},
        diff: {},
      );
    }
    return _$ScanResultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ScanResultToJson(this);
}

@JsonSerializable()
class GeneralInfo {
  String task_name;
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

@JsonSerializable()
class Host {
  String ip;
  List<Port> ports;
  String status;
  Map<String, Vulnerability> vulns;

  Host({
    required this.ip,
    required this.ports,
    required this.status,
    required this.vulns,
  });

  factory Host.fromJson(Map<String, dynamic> json) => _$HostFromJson(json);
  Map<String, dynamic> toJson() => _$HostToJson(this);
}

@JsonSerializable()
class Port {
  int port;
  String protocol;
  String service;
  String state;

  Port({
    required this.port,
    required this.protocol,
    required this.service,
    required this.state,
  });

  factory Port.fromJson(Map<String, dynamic> json) => _$PortFromJson(json);
  Map<String, dynamic> toJson() => _$PortToJson(this);
}

@JsonSerializable()
class Vulnerability {
  String cpe;
  String cvss;
  String cvss_vector;
  List<String> cwe;
  String description;
  String id;
  int port;
  String references;
  List<String> solutions;

  Vulnerability({
    required this.cpe,
    required this.cvss,
    required this.cvss_vector,
    required this.cwe,
    required this.description,
    required this.id,
    required this.port,
    required this.references,
    required this.solutions,
  });

  factory Vulnerability.fromJson(Map<String, dynamic> json) =>
      _$VulnerabilityFromJson(json);
  Map<String, dynamic> toJson() => _$VulnerabilityToJson(this);
}

@JsonSerializable()
class Diff {
  Map<String, Map<String, Vulnerability>> added;
  Map<String, Map<String, Vulnerability>> removed;

  Diff({
    required this.added,
    required this.removed,
  });

  factory Diff.fromJson(Map<String, dynamic> json) {
    return Diff(
      added: (json['+'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(
              k,
              (v as Map<String, dynamic>).map((k, v) => MapEntry(
                  k, Vulnerability.fromJson(v as Map<String, dynamic>))))) ??
          {},
      removed: (json['-'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(
              k,
              (v as Map<String, dynamic>).map((k, v) => MapEntry(
                  k, Vulnerability.fromJson(v as Map<String, dynamic>))))) ??
          {},
    );
  }

  Map<String, dynamic> toJson() => _$DiffToJson(this);
}
