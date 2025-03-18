import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HorizontalScrollChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horizontal Scroll Chart'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: 2000, // Ширина контейнера (можно настроить под ваши данные)
          height: 300, // Высота диаграммы
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 1),
                    FlSpot(1, 3),
                    FlSpot(2, 2),
                    FlSpot(3, 5),
                    FlSpot(4, 4),
                    FlSpot(5, 7),
                    FlSpot(6, 6),
                    FlSpot(7, 9),
                    FlSpot(8, 8),
                    FlSpot(9, 10),
                  ],
                  isCurved: true,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: true),
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: const Color(0xff37434d),
                ),
              ),
              gridData: FlGridData(show: true),
            ),
          ),
        ),
      ),
    );
  }
}
