import 'package:flutter/material.dart';
import 'package:net_runner/core/data/statusConverter.dart';
import 'package:net_runner/core/data/typeConverter.dart';
import 'package:net_runner/core/domain/api/models/task/task_serial.dart';
import 'package:net_runner/utils/constants/themes/task_status_color.dart';

class TaskCard extends StatefulWidget {
  final ModelTask task;
  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.task.percent / 100,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  void _updateProgress(int newPercent) {
    double newProgress = newPercent / 100;

    _progressAnimation = Tween<double>(
      begin: _currentProgress, // Начинаем с текущего значения
      end: newProgress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward(from: 0); // Перезапускаем анимацию
    _currentProgress = newProgress; // Обновляем текущее значение
  }

  @override
  void didUpdateWidget(TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.percent != widget.task.percent) {
      _updateProgress(widget.task.percent);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          return Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: getTaskStatusColor(widget.task.status),
                  width: 5,
                ),
              ),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                ),
              ],
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(widget.task.number_task.toString()),
                  ),
                  Expanded(
                    child: Text(
                      widget.task.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (constraints.minWidth <= 600) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Прогресс  ${widget.task.workingStatus ?? ""}'),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: AnimatedBuilder(
                                      animation: _progressAnimation,
                                      builder: (context, child) {
                                        return LinearProgressIndicator(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          value: _progressAnimation.value
                                              .clamp(0.0, 1.0),
                                          minHeight: 10,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text('${widget.task.percent}%'),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Статус"),
                        Text(
                          statusConverter(widget.task.status),
                          style: TextStyle(
                            color: getTaskStatusColor(widget.task.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Тип"),
                        Text(typeConverter(widget.task.type)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (constraints.maxWidth >= 600) {
          return Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: getTaskStatusColor(widget.task.status),
                  width: 5,
                ),
              ),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                ),
              ],
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(widget.task.number_task.toString()),
                  ),
                  Expanded(
                    child: Text(
                      widget.task.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Статус"),
                        Text(
                          statusConverter(widget.task.status),
                          style: TextStyle(
                            color: getTaskStatusColor(widget.task.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Тип"),
                        Text(typeConverter(widget.task.type)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: getTaskStatusColor(widget.task.status),
                  width: 5,
                ),
              ),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                ),
              ],
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(widget.task.number_task.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Статус"),
                        Text(
                          statusConverter(widget.task.status),
                          style: TextStyle(
                            color: getTaskStatusColor(widget.task.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(typeConverter(widget.task.type)),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
