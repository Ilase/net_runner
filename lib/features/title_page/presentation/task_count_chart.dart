import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_runner/core/data/data_converter.dart';
import 'package:net_runner/core/domain/api/models/task/task_serial.dart';

class TaskCountChart extends StatelessWidget {
  final List<ModelTask> tasks;

  const TaskCountChart({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<DateTime, int> scanCounts = {};

    for (var task in tasks) {
      if (task.CreatedAt != null) {
        DateTime date = convertUnixToDateTime(task.CreatedAt!);
        DateTime dayOnly = DateTime(date.year, date.month, date.day);
        scanCounts[dayOnly] = (scanCounts[dayOnly] ?? 0) + 1;
      }
    }

    List<DateTime> dates = scanCounts.keys.toList()..sort();

    List<FlSpot> spots = dates.map((date) {
      return FlSpot(
          date.millisecondsSinceEpoch.toDouble(), scanCounts[date]!.toDouble());
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: Duration(days: 1)
                          .inMilliseconds
                          .toDouble(), // Интервал 1 день
                      getTitlesWidget: (value, meta) {
                        DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Transform(
                            transform: Matrix4.rotationZ(0.4),
                            child: Text(
                              DateFormat('MM-dd').format(date),
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    color: Colors.black,
                    barWidth: 3,
                    isStrokeCapRound: false,
                    belowBarData: BarAreaData(
                      show: false,
                      color: Colors.black,
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
                minX: dates.first.millisecondsSinceEpoch.toDouble(),
                maxX: dates.last.millisecondsSinceEpoch.toDouble(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
