import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class GraphicChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('График по дням')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chart(
          data: [
            {'day': 'Пн', 'value': 3},
            {'day': 'Вт', 'value': 2},
            {'day': 'Ср', 'value': 5},
            {'day': 'Чт', 'value': 3},
            {'day': 'Пт', 'value': 4},
            {'day': 'Сб', 'value': 6},
            {'day': 'Вс', 'value': 5},
          ],
          variables: {
            'day': Variable(
              accessor: (Map map) => map['day'] as String,
            ),
            'value': Variable(
              accessor: (Map map) => map['value'] as num,
            ),
          },
          marks: [
            IntervalMark(),
          ],
          axes: [
            Defaults.horizontalAxis,
            Defaults.verticalAxis,
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: GraphicChartSample()));
