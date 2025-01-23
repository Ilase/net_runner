import 'package:flutter/material.dart';

import 'api_service.dart';
import 'task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks & Hosts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _tasks;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasks = ApiService().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks & Hosts'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshTasks, // Reload tasks data
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks available'));
          }

          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskWidget(task: task); // Use TaskWidget to display tasks
            },
          );
        },
      ),
    );
  }
}



class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Future<Task> _taskDetails;

  @override
  void initState() {
    super.initState();
    _taskDetails = ApiService().fetchTaskDetails(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: FutureBuilder<Task>(
        future: _taskDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}*'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No task details available*'));
          }

          final task = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Task ID: ${task.id}'),
                Text('Name: ${task.name}'),
                Text('Type: ${task.type}'),
                Text('Status: ${task.status}'),
                Text('Progress: ${task.percent}%'),
                SizedBox(height: 8),
                Text('Parameters:'),
                ...task.params.entries.map((entry) => Text('${entry.key}: ${entry.value}')),
                SizedBox(height: 8),
                Text('Hosts:'),
                ...task.hosts.map((host) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text('IP: ${host.ip}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${host.name ?? "N/A"}'),
                        Text('Group: ${host.group ?? "N/A"}'),
                        Text('Task List: ${host.taskList ?? "N/A"}'),
                        Text('Created: ${host.formatDate(host.createdAt)}'),
                        Text('Updated: ${host.formatDate(host.updatedAt)}'),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}