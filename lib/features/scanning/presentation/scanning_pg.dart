import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/pentest_report_controller/pentest_report_controller_cubit.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';

class ScanningPg extends StatefulWidget {
  const ScanningPg({super.key});

  @override
  State<ScanningPg> createState() => _ScanningPgState();
}

class _ScanningPgState extends State<ScanningPg> {
  Map<String, dynamic>? _selectedItem;
  List<dynamic>? _selectedItemHosts;

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
          ],
        ),
        child: Column(
          children: [
            /// Поисковая строка
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      /// Перезагрузка списка
                      context.read<ApiBloc>().add(FetchTaskListEvent());
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
                  /// Левая панель (сканирования)
                  Expanded(
                    flex: _selectedItem == null
                        ? 7
                        : 10, // Расширяется, если нет выбранного элемента
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text('Сканирования*'),
                              SizedBox(height: 8),
                              Divider(),
                              SizedBox(height: 8),
                              Expanded(
                                child:
                                    BlocBuilder<TaskListCubit, TaskListState>(
                                  builder: (context, state) {
                                    if (state is FilledState) {
                                      final List<dynamic> list =
                                          state.list["taskList"];
                                      ntLogger.t(state.list["taskList"].length);
                                      return Center(
                                        child: ListView.builder(
                                          reverse: true,
                                          itemCount: list.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  context.read<ApiBloc>().add(
                                                      GetReport(
                                                          task_number: list[
                                                                  index]
                                                              ["number_task"]));
                                                  setState(() {
                                                    _selectedItem = list[index];
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(3, 3),
                                                        color: Colors.grey,
                                                        blurRadius: 15,
                                                      )
                                                    ],
                                                  ),
                                                  width: double
                                                      .infinity, // Контейнер занимает всю ширину
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      16.0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween, // Разместить элементы равномерно
                                                      children: [
                                                        Text(list[index]["ID"]
                                                            .toString()),
                                                        Expanded(
                                                          // Растягиваем колонку по ширине
                                                          child: Column(
                                                            children: [
                                                              Text(list[index][
                                                                      "number_task"]
                                                                  .toString()),
                                                              Text(list[index]
                                                                  ["name"]),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(list[
                                                                      index]
                                                                  ["percent"]
                                                              .toString()),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text("Статус"),
                                                              Text(list[index]
                                                                  ["status"]),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else if (state is LoadingState) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      return Center(child: Text('ReloadList'));
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Правая панель (подробности)
                  AnimatedContainer(
                    height: double.infinity,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: _selectedItem == null
                        ? 0
                        : MediaQuery.of(context).size.width * 0.7,
                    child: _selectedItem == null
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 16.0,
                              left: 16.0,
                              right: 16.0,
                              bottom: 16.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                                child: BlocBuilder<PentestReportControllerCubit,
                                        PentestReportControllerState>(
                                    builder: (context, state) {
                                  if (state is LoadingTaskState) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is GetTaskState) {
                                    return Center(
                                      child: Text('GOOD'),
                                    );
                                  } else {
                                    return Center(
                                      child: Text('OOPS'),
                                    );
                                  }
                                }),
                                // child: Column(
                                //   mainAxisSize: MainAxisSize.min,
                                //   children: [
                                //     Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Text(
                                //             'Сканирование: ${_selectedItem!["name"]}'),
                                //         Text(
                                //             '${_selectedItem!["number_task"]}'),
                                //         IconButton(
                                //           onPressed: () {
                                //             setState(() {
                                //               _selectedItem = null;
                                //               _selectedItemHosts = null;
                                //             });
                                //           },
                                //           icon: Icon(Icons.close),
                                //         ),
                                //       ],
                                //     ),
                                //     Divider(),
                                //     Align(
                                //       alignment: Alignment.centerLeft,
                                //       child: Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [],
                                //       ),
                                //     ),
                                //     Divider(),
                                //     Align(
                                //       alignment: Alignment.centerLeft,
                                //       child: Text('Хосты'),
                                //     ),
                                //     if (_selectedItemHosts != null &&
                                //         _selectedItemHosts!.isNotEmpty)
                                //       ..._selectedItemHosts!
                                //           .map((host) => ListTile(
                                //                 title: Text(host["name"]),
                                //                 subtitle: Text(host["ip"]),
                                //               )),
                                //     if (_selectedItemHosts == null ||
                                //         _selectedItemHosts!.isEmpty)
                                //       Padding(
                                //         padding: const EdgeInsets.all(8.0),
                                //         child: Text('Хостов нет',
                                //             style:
                                //                 TextStyle(color: Colors.grey)),
                                //       ),
                                //   ],
                                // ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
