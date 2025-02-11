



class Api {

  final String _api = '/api';
  final String _stringVersion = '/v1';
  static const Map<String,String> apiRequest = {
    "ping" : '/ping',
    "get-task-list" : '/task',
    "get-host-list" : '/host',
    "web-socket" : '/ws',
    "get-group-list" : '/groups' //rewrite

  };
  static const Map<String,String> taskType ={
    "pentest" : 'pentest',
  };

  String prefix(){
    return _api + _stringVersion;
  }

}
