class TaskLoader {
  final List<Future<dynamic> Function()> tasks;
  TaskLoader({required this.tasks});

  Future<dynamic> runSequentially() async {
    for (var task in tasks) {
      await task();
    }
  }

  Future<dynamic> runInParallel() async {
    await Future.wait(tasks.map((task) => task()));
  }
}
