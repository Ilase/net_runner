import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_runner/core/domain/api/models/task/task_serial.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class TaskCountChart extends StatelessWidget {
  final List<ModelTask> tasks;

  const TaskCountChart({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Группируем задачи по дате
    Map<String, int> scanCounts = {};

    for (var task in tasks) {
      if (task.CreatedAt != null) {
        String date =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(task.CreatedAt!));
        scanCounts[date] = (scanCounts[date] ?? 0) + 1;
      }
    }

    // Сортируем даты
    List<String> dates = scanCounts.keys.toList()..sort();
    List<BarChartGroupData> barGroups = List.generate(dates.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: scanCounts[dates[index]]!.toDouble(),
            color: AppTheme.lightTheme.primaryColor,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Количество сканирований по дням",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text("Количество",
                        style: TextStyle(fontSize: 12)),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget:
                        Text("Дата", style: TextStyle(fontSize: 12)),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < dates.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(dates[value.toInt()],
                                style: TextStyle(fontSize: 10)),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
