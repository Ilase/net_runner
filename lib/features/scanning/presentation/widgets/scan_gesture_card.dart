import 'package:flutter/material.dart';
import 'package:net_runner/features/scanning/presentation/scan_view_page.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class ScanGestureCard extends StatefulWidget {
  final item;
  String title;
  String status;
  String completeTime;
  String scanType;
  num percent;
  ScanGestureCard({
    super.key,
    required this.item,
    required this.title,
    required this.status,
    required this.completeTime,
    required this.scanType,
    required this.percent
  });

  @override
  State<ScanGestureCard> createState() => _ScanGestureCardState();
}

class _ScanGestureCardState extends State<ScanGestureCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context) =>ScanViewPage(taskName: widget.title)));
      },
      child:
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: AppTheme.lightTheme.colorScheme.secondary,
                offset: const Offset(3, 6)
              )
            ]
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 3, 0, 3),
                alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15))
                  ),
                child: Text(widget.title,
                style: AppTheme.lightTheme.textTheme.headlineSmall),
            )
            ),
            Expanded(
                flex: 3,
                child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 3, 0, 3),
                    decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15))
                    ),
                  child: Row(
                    children:
                    [
                      Expanded(
                      flex: 3,
                      child:
                      Text(
                          'Scan type: ${widget.scanType}*',
                          style: AppTheme.lightTheme.textTheme.bodySmall,//name type of scanning
                      )
                      ),
                      Expanded(
                          flex: 3,
                          child:
                          Text(
                            'Updated at: ${widget.completeTime}*',
                            style: AppTheme.lightTheme.textTheme.bodySmall,//name type of scanning
                          )
                      ),
                      Expanded(
                          child: TweenAnimationBuilder(
                            curve: Curves.bounceIn,
                            duration: Duration(microseconds: 1000),
                            tween: Tween<double>(
                              begin: 0,
                              end: widget.percent.toDouble()
                            ),
                            builder: (context, value, _) => LinearProgressIndicator(
                              semanticsLabel: 'Progress',
                              value: value,
                            ),
                          )
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                          flex: 2,
                          child:
                          Text(
                            '${widget.percent.toDouble()}%',
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



