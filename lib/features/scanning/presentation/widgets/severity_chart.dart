import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SeverityPieChart extends StatelessWidget {
  final Map<String, int> severityCount;

  SeverityPieChart({required this.severityCount});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'Незначительный': Colors.grey,
      'Низкий': Colors.green,
      'Средний': Colors.orange,
      'Высокий': Colors.redAccent,
      'Критический': Colors.red,
    };

    final List<PieChartSectionData> sections = severityCount.entries
        .where((entry) => entry.value > 0) // Исключаем нулевые значения
        .map((entry) {
      return PieChartSectionData(
        color: colors[entry.key] ?? Colors.blue,
        value: entry.value.toDouble(),
        title: '${entry.value}', // Показываем количество
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        borderData: FlBorderData(show: false),
        sectionsSpace: 2, // Промежуток между секторами
        centerSpaceRadius:
            40, // Радиус центра (можно убрать, если нужен полный круг)
      ),
    );
  }
}
