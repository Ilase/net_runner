
class GeneralInfo {
  final int down;
  final String elapsed;
  final String end;
  final String start;
  final String summary;
  final int total;
  final int up;
  final String version;

  GeneralInfo({
    required this.down,
    required this.elapsed,
    required this.end,
    required this.start,
    required this.summary,
    required this.total,
    required this.up,
    required this.version,
  });

  factory GeneralInfo.fromJson(Map<String, dynamic> json) {
    return GeneralInfo(
      down: json['down'],
      elapsed: json['elapsed'],
      end: json['end'],
      start: json['start'],
      summary: json['summary'],
      total: json['total'],
      up: json['up'],
      version: json['version'],
    );
  }
}

class Port {
  final int port;
  final String protocol;
  final String service;
  final String state;
  final List<Script>? scripts;

  Port({
    required this.port,
    required this.protocol,
    required this.service,
    required this.state,
    this.scripts,
  });

  factory Port.fromJson(Map<String, dynamic> json) {
    return Port(
      port: json['port'],
      protocol: json['protocol'],
      service: json['service'],
      state: json['state'],
      scripts: json['scripts'] != null
          ? (json['scripts'] as List)
          .map((script) => Script.fromJson(script))
          .toList()
          : null,
    );
  }
}

class Script {
  final String id;
  final String output;

  Script({required this.id, required this.output});

  factory Script.fromJson(Map<String, dynamic> json) {
    return Script(
      id: json['id'],
      output: json['output'],
    );
  }
}

class Host {
  final String ip;
  final String status;
  final List<Port> ports;

  Host({
    required this.ip,
    required this.status,
    required this.ports,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      ip: json['ip'],
      status: json['status'],
      ports: (json['ports'] as List)
          .map((port) => Port.fromJson(port))
          .toList(),
    );
  }
}

class NmapResult {
  final GeneralInfo generalInfo;
  final List<Host> hosts;

  NmapResult({
    required this.generalInfo,
    required this.hosts,
  });

  factory NmapResult.fromJson(Map<String, dynamic> json) {
    return NmapResult(
      generalInfo: GeneralInfo.fromJson(json['general_info']),
      hosts: (json['hosts'] as List)
          .map((host) => Host.fromJson(host))
          .toList(),
    );
  }
}