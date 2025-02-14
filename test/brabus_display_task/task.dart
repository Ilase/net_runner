import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'main.dart';

class Task {
  final int id;
  final String numberTask;
  final String name;
  final String type;
  final String status;
  final int percent;
  final List<Host> hosts;
  final Map<String, dynamic> params;

  Task({
    required this.id,
    required this.numberTask,
    required this.name,
    required this.type,
    required this.status,
    required this.percent,
    required this.hosts,
    required this.params,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['ID'],
      numberTask: json['number_task'],
      name: json['name'],
      type: json['type'],
      status: json['status'],
      percent: json['percent'],
      hosts: (json['hosts'] as List)
          .map((hostJson) => Host.fromJson(hostJson))
          .toList(),
      params: json['params'],
    );
  }
}

class Host {
  final int id;
  final String ip;
  final String createdAt;
  final String updatedAt;
  final String? name;
  final String? group;
  final String? taskList;

  Host({
    required this.id,
    required this.ip,
    required this.createdAt,
    required this.updatedAt,
    this.name,
    this.group,
    this.taskList,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['ID'],
      ip: json['ip'],
      createdAt: json['CreatedAt'],
      updatedAt: json['UpdatedAt'],
      name: json['name']?.isEmpty ?? true ? null : json['name'],
      group: json['Groups']?.isEmpty ?? true ? null : json['Groups'],
      taskList: json['task_list']?.isEmpty ?? true ? null : json['task_list'],
    );
  }

  // Форматирование даты
  String formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }
}

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${task.name} (${task.numberTask})'),
      subtitle: Text('Status: ${task.status} | Progress: ${task.percent}%'),
      onTap: () {
        // Navigate to the TaskDetailScreen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(taskId: task.numberTask),
          ),
        );
      },
    );
  }
}
