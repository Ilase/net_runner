// import 'package:net_runner/features/scanning/data/data_parce.dart';
import 'package:net_runner/core/data/logger.dart';

class ApiScanResponse {
  late GeneralInfo generalInfo;
  late List<Host> hosts = [];

  ApiScanResponse(Map<String, dynamic> jsonData) {
    try {
      generalInfo = GeneralInfo.fromJson(jsonData["general_info"] ?? {});

      var hostsData = jsonData["hosts"];
      if (hostsData is List) {
        for (var host in hostsData) {
          if (host is Map<String, dynamic>) {
            List<PortInfo> rawPorts = (host["ports"] as List<dynamic>? ?? [])
                .map((port) => PortInfo.fromJson(port as Map<String, dynamic>))
                .toList();

            List<Vuln> rawVulns = (host["vulns"] as List<dynamic>? ?? [])
                .map((vuln) => Vuln.fromJson(vuln as Map<String, dynamic>))
                .toList();

            hosts.add(Host(
              ip: host["ip"] ?? "Unknown",
              ports: rawPorts,
              vulns: rawVulns,
              status: host["status"] ?? "Unknown",
            ));
          }
        }
      }
    } catch (e) {
      ntLogger.e("Error parsing ApiScanResponse: $e");
    }
  }
}


class GeneralInfo {
  String taskName;
  String elapsed; // scan time
  String startTime; 
  String endTime;
  String summary;
  int total;
  int up;
  int down;
  String version;

  factory GeneralInfo.fromJson(Map<String, dynamic> json) => GeneralInfo(
    taskName: json["task_name"] ?? "???",
    elapsed: json["elapsed"] ?? "???",
    startTime: json["start"] ?? "???",
    endTime: json["end"] ?? "???",
    summary: json["summary"] ?? "???",
    total: json["total"] ?? 0,
    up: json["up"] ?? 0,
    down: json["down"] ?? 0,
    version: json["version"] ?? "???",
  );

  GeneralInfo({
    required this.taskName,
    required this.elapsed,
    required this.startTime,
    required this.endTime,
    required this.summary,
    required this.total,
    required this.up,
    required this.down,
    required this.version,
  });
}



class Host {
  String ip;
  List<PortInfo> ports;
  List<Vuln> vulns;
  String status;


  Host({
    required this.ip,
    required this.ports,
    required this.vulns,
    required this.status,
  });
}

class Vuln {
  String cveId;
  String cpe;
  String cvss;
  String cvssString;
  String description;
  int port;
  String references;

  factory Vuln.fromJson(Map<String, dynamic> json) => Vuln(
    cveId: json["id"] ?? "???",
    cpe: json["cpe"] ?? "???",
    cvss: json["cvss"] ?? "???",
    cvssString: json["cvss_vector"] ?? "???",
    port: json["port"] ?? 0,
    references: json["references"] ?? "???",
    description: json["description"] ?? "???",
  );

  Vuln({
    required this.cveId,
    required this.cpe,
    required this.cvss,
    required this.cvssString,
    required this.description,
    required this.port,
    required this.references,
  });

}

class PortInfo {
  int port;
  String protocol;
  String service;
  String state;

  factory PortInfo.fromJson(Map<String, dynamic> json) => PortInfo(
    port: json["port"] ?? 0,
    protocol: json["protocol"] ?? "???",
    service: json["service"] ?? "???",
    state: json["state"] ?? "???",
  );

  PortInfo({
    required this.port,
    required this.protocol,
    required this.service,
    required this.state,
  });
}
