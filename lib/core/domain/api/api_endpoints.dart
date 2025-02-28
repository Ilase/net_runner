class ApiEndpoints {
  Map<String, Uri> endpoints = {};
  String baseApiPath = 'api/v1';
  ApiEndpoints({
    required String host,
    required int port,
    required String scheme,
  }) {
    endpoints = {
      "check-connection": Uri(
        scheme: scheme,
        port: port,
        host: host,
        path: baseApiPath,
      ),
      "get-task-list": Uri(
        scheme: scheme,
        port: port,
        host: host,
        path: '$baseApiPath/task',
      ),
      "pentest-report": Uri(
        scheme: scheme,
        port: port,
        host: host,
        path: '$baseApiPath/pentest',
      ),
      "get-host-list": Uri(
        scheme: scheme,
        port: port,
        host: host,
        path: '$baseApiPath/host',
      ),
      "get-group-list": Uri(
        scheme: scheme,
        port: port,
        host: host,
        path: '$baseApiPath/group',
      ),
      "ws": Uri(
        scheme: "ws",
        port: port,
        host: host,
        path: '$baseApiPath/ws',
      ),
      "get-ping-list": Uri(
        scheme: scheme,
        port: port,
        host: host,
        path: '$baseApiPath/ping',
      ),
    };
  }

  Uri getUri(String key,
      {List<String> extraPaths = const [], Map<String, String>? queryParams}) {
    final baseUri = endpoints[key];
    if (baseUri == null) {
      throw ArgumentError("Endpoint '$key' is missing");
    }

    final newPath = [baseUri.path, ...extraPaths].join('/');
    return baseUri.replace(path: newPath, queryParameters: queryParams);
  }
}
