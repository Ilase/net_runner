import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/features/scanning/presentation/widgets/scan_gesture_card.dart';

class ScanningPg extends StatefulWidget {
  const ScanningPg({super.key});

  @override
  State<ScanningPg> createState() => _ScanningPgState();
}

class _ScanningPgState extends State<ScanningPg> {
  Map<String, dynamic>? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(3, 3),
                blurRadius: 10,
                color: Colors.grey,
              ),
            ]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      /// Поиск
                    },
                    icon: Icon(Icons.refresh),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Поиск'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ),

            /// Основное тело
            Expanded(
              child: Row(
                children: [
                  /// Левая панель
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(3, 3),
                              blurRadius: 10,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(3, 3),
                                blurRadius: 10,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Сканирования*'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  /// Правая панель
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(3, 3),
                              blurRadius: 10,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(3, 3),
                                blurRadius: 10,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Сканирования*'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 55,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           const Text(
            //             'Сканирования*',
            //             //style: AppTheme.lightTheme.textTheme.titleMedium
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           ElevatedButton(
            //               onPressed: () {
            //                 Navigator.of(context).pushNamed('/create-scan');
            //               },
            //               child: Text('New scan*'))
            //         ],
            //       ),
            //       IconButton(
            //         onPressed: () {},
            //         icon: const Icon(Icons.refresh),
            //       ),
            //       Expanded(
            //         child: Row(
            //           children: [
            //             Expanded(
            //               child: Padding(
            //                 padding: const EdgeInsets.only(
            //                   top: 16.0,
            //                   left: 16.0,
            //                   right: 16.0,
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
