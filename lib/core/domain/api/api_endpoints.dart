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
        scheme: scheme,
        port: port,
        host: host,
        path: '$baseApiPath/ws',
      ),
    };
  }

  Uri getUri(String key, {List<String> extraPaths = const []}) {
    final baseUri = endpoints[key];
    if (baseUri == null) {
      throw ArgumentError("Endpoing '$key is missing");
    }
    final newPath = [baseUri.path, ...extraPaths].join('/');
    return baseUri.replace(path: newPath);
  }
}
