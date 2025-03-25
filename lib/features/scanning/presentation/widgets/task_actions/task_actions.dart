import 'package:flutter/material.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class TaskActions extends StatelessWidget {
  const TaskActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 2, color: AppTheme.lightTheme.primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('Действия с задачей'),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: OutlinedButton.icon(
                onPressed: null,
                label: Text("Удалить задачу"),
                icon: Icon(Icons.delete),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: OutlinedButton.icon(
                onPressed: null,
                label: Text("Изменить задачу"),
                icon: Icon(Icons.edit),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: OutlinedButton.icon(
                onPressed: null,
                label: Text("Повторить задачу"),
                icon: Icon(Icons.repeat),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: OutlinedButton.icon(
                onPressed: null,
                label: Text("Добавить в график"),
                icon: Icon(Icons.calendar_today),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
