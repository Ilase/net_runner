class NmapScanResult {
  final GeneralInfo generalInfo;
  final List<Host> hosts;

  NmapScanResult({
    required this.generalInfo,
    required this.hosts,
  });

  factory NmapScanResult.fromJson(Map<String, dynamic> json) {
    return NmapScanResult(
      generalInfo: GeneralInfo.fromJson(json['general_info']),
      hosts: (json['hosts'] as List).map((host) => Host.fromJson(host)).toList(),
    );
  }
}

class GeneralInfo {
  final int down;
  final double elapsed;
  final String end;
  final String start;
  final String summary;
  final String taskName;
  final int total;
  final int up;
  final String version;

  GeneralInfo({
    required this.down,
    required this.elapsed,
    required this.end,
    required this.start,
    required this.summary,
    required this.taskName,
    required this.total,
    required this.up,
    required this.version,
  });

  factory GeneralInfo.fromJson(Map<String, dynamic> json) {
    return GeneralInfo(
      down: json['down'],
      elapsed: double.parse(json['elapsed']), // Parse the elapsed field as a double
      end: json['end'],
      start: json['start'],
      summary: json['summary'],
      taskName: json['task_name'],
      total: json['total'],
      up: json['up'],
      version: json['version'],
    );
  }
}

class Host {
  final String ip;
  final List<Port> ports;
  final String status;
  final List<Vulnerability>? vulnerabilities; // Make vulnerabilities nullable

  Host({
    required this.ip,
    required this.ports,
    required this.status,
    this.vulnerabilities,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      ip: json['ip'],
      ports: (json['ports'] as List).map((port) => Port.fromJson(port)).toList(),
      status: json['status'],
      vulnerabilities: json['vulns'] != null ? (json['vulns'] as List).map((vuln) => Vulnerability.fromJson(vuln)).toList() : null,
    );
  }
}

class Port {
  final int port;
  final String protocol;
  final String service;
  final String state;

  Port({
    required this.port,
    required this.protocol,
    required this.service,
    required this.state,
  });

  factory Port.fromJson(Map<String, dynamic> json) {
    return Port(
      port: json['port'],
      protocol: json['protocol'],
      service: json['service'],
      state: json['state'],
    );
  }
}

class Vulnerability {
  final String cpe;
  final String cvss;
  final String cvssVector;
  final String? cwe;
  final String description;
  final String id;
  final int port;
  final String references;
  final String? solutions;

  Vulnerability({
    required this.cpe,
    required this.cvss,
    required this.cvssVector,
    required this.description,
    required this.id,
    required this.port,
    required this.references,
    this.cwe,
    this.solutions,
  });

  factory Vulnerability.fromJson(Map<String, dynamic> json) {
    return Vulnerability(
      cpe: json['cpe'],
      cvss: json['cvss'],
      cvssVector: json['cvss_vector'],
      description: json['description'],
      id: json['id'],
      port: json['port'],
      references: json['references'],
      cwe: json['cwe'],
      solutions: json['solutions'],
    );
  }
}
