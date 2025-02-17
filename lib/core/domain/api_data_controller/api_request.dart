



class Api {

  static String api = '/api';
  static String stringVersion = '/v1';
  static const Map<String,String> apiRequest = {
    "ping" : '/ping',
    "get-task-list" : '/task',
    "get-host-list" : '/host',
    "web-socket" : '/ws',
    "get-group-list" : '/groups' //rewrite

  };
  static const Map<String,String> taskType ={
    "pentest" : 'pentest',
    "networkscan" : 'networkscan'
  };

  String get prefix => api + stringVersion;

}
