// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_responce.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResult _$ScanResultFromJson(Map<String, dynamic> json) => ScanResult(
      general_info:
          GeneralInfo.fromJson(json['general_info'] as Map<String, dynamic>),
      hosts: (json['hosts'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Host.fromJson(e as Map<String, dynamic>)),
      ),
      diff: (json['diff'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Diff.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ScanResultToJson(ScanResult instance) =>
    <String, dynamic>{
      'general_info': instance.general_info,
      'hosts': instance.hosts,
      'diff': instance.diff,
    };

GeneralInfo _$GeneralInfoFromJson(Map<String, dynamic> json) => GeneralInfo(
      task_name: json['task_name'] as String,
      start: json['start'] as String,
      end: json['end'] as String,
      version: json['version'] as String,
      elapsed: json['elapsed'] as String,
      summary: json['summary'] as String,
      up: (json['up'] as num).toInt(),
      down: (json['down'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$GeneralInfoToJson(GeneralInfo instance) =>
    <String, dynamic>{
      'task_name': instance.task_name,
      'start': instance.start,
      'end': instance.end,
      'version': instance.version,
      'elapsed': instance.elapsed,
      'summary': instance.summary,
      'up': instance.up,
      'down': instance.down,
      'total': instance.total,
    };

Host _$HostFromJson(Map<String, dynamic> json) => Host(
      ip: json['ip'] as String,
      ports: (json['ports'] as List<dynamic>)
          .map((e) => Port.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      vulns: (json['vulns'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, Vulnerability.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$HostToJson(Host instance) => <String, dynamic>{
      'ip': instance.ip,
      'ports': instance.ports,
      'status': instance.status,
      'vulns': instance.vulns,
    };

Port _$PortFromJson(Map<String, dynamic> json) => Port(
      port: (json['port'] as num).toInt(),
      protocol: json['protocol'] as String,
      service: json['service'] as String,
      state: json['state'] as String,
    );

Map<String, dynamic> _$PortToJson(Port instance) => <String, dynamic>{
      'port': instance.port,
      'protocol': instance.protocol,
      'service': instance.service,
      'state': instance.state,
    };

Vulnerability _$VulnerabilityFromJson(Map<String, dynamic> json) =>
    Vulnerability(
      cpe: json['cpe'] as String,
      cvss: json['cvss'] as String,
      cvss_vector: json['cvss_vector'] as String,
      cwe: (json['cwe'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String,
      id: json['id'] as String,
      port: (json['port'] as num).toInt(),
      references: json['references'] as String,
      solutions:
          (json['solutions'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$VulnerabilityToJson(Vulnerability instance) =>
    <String, dynamic>{
      'cpe': instance.cpe,
      'cvss': instance.cvss,
      'cvss_vector': instance.cvss_vector,
      'cwe': instance.cwe,
      'description': instance.description,
      'id': instance.id,
      'port': instance.port,
      'references': instance.references,
      'solutions': instance.solutions,
    };

Diff _$DiffFromJson(Map<String, dynamic> json) => Diff(
      added: (json['added'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(
                  k, Vulnerability.fromJson(e as Map<String, dynamic>)),
            )),
      ),
      removed: (json['removed'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(
                  k, Vulnerability.fromJson(e as Map<String, dynamic>)),
            )),
      ),
    );

Map<String, dynamic> _$DiffToJson(Diff instance) => <String, dynamic>{
      'added': instance.added,
      'removed': instance.removed,
    };
