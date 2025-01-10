import 'package:flutter/material.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class MtGestureCard extends StatefulWidget {
  String title;
  String status;
  MtGestureCard({super.key, required this.title, required this.status});

  @override
  State<MtGestureCard> createState() => _MtGestureCardState();
}

class _MtGestureCardState extends State<MtGestureCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child:
        Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: AppTheme.lightTheme.colorScheme.secondary,
                offset: Offset(3, 6)
              )
            ]
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 3, 0, 3),
                alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                  ),
                child: Text(widget.title,
                style: AppTheme.lightTheme.textTheme.headlineSmall),
            )
            ),
            Expanded(
                flex: 3,
                child: Container(
                    padding: EdgeInsets.fromLTRB(10, 3, 0, 3),
                    decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
                    ),
                  child: Row(
                    children:
                    [
                      Expanded(
                      flex: 3,
                      child:
                      Text(
                          'Аудит в режиме "Пентест"',
                          style: AppTheme.lightTheme.textTheme.bodySmall,//name type of scanning
                      )
                      ),
                      Expanded(
                          flex: 3,
                          child:
                          Text(
                            'Завершен: 26.12.2024 18:05:42',
                            style: AppTheme.lightTheme.textTheme.bodySmall,//name type of scanning
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child:
                          Text(
                            '42 элемента',
                            style: AppTheme.lightTheme.textTheme.bodySmall,//name type of scanning
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child:
                          Text(
                            widget.status,
                            style: AppTheme.lightTheme.textTheme.bodySmall,//name type of scanning
                          )
                      ),
                    ],
                  ),
            )
            )
          ],
        ),
      )
    );
  }
}



