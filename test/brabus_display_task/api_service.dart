import 'dart:convert';
import 'package:http/http.dart' as http;
import 'task.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.20.140:3001/api/v1/task';

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // New method to fetch task details
  Future<Task> fetchTaskDetails(String taskId) async {
    final response = await http.get(Uri.parse('$_baseUrl/$taskId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Task.fromJson(jsonData);
    } else {
      throw Exception('Failed to load task details');
    }
  }
}