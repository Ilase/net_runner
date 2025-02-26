import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphic/graphic.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/data/task_report_serial/pentest_report_serial.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/pentest_report_controller/pentest_report_controller_cubit.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';
import 'package:net_runner/features/scanning/presentation/create_scan_page.dart';
import 'package:net_runner/utils/routes/router.dart';

class ScanningPg extends StatefulWidget {
  const ScanningPg({super.key});

  @override
  State<ScanningPg> createState() => _ScanningPgState();
}

class _ScanningPgState extends State<ScanningPg>
    with SingleTickerProviderStateMixin {
  final heatmapChannel = StreamController<Selected?>.broadcast();
  Map<String, dynamic>? _selectedItem;
  List<dynamic>? _selectedItemHosts;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          /// Поисковая строка
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: null,
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
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    /// Перезагрузка списка
                                    context
                                        .read<ApiBloc>()
                                        .add(FetchTaskListEvent());
                                  },
                                  icon: Icon(Icons.refresh),
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration:
                                        InputDecoration(labelText: 'Поиск'),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.search),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(createRoute(CreateScanPage()));
                                    },
                                    icon: Icon(Icons.add_circle_outline)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(),
                            SizedBox(height: 8),
                            Expanded(
                              child: BlocBuilder<TaskListCubit, TaskListState>(
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
                                            padding: const EdgeInsets.all(16.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                context.read<ApiBloc>().add(
                                                    GetReport(
                                                        task_number: list[index]
                                                            ["number_task"]));
                                                setState(() {
                                                  _selectedItem = list[index];
                                                });
                                              },
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  if (constraints.maxWidth >
                                                      400) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                Offset(3, 3),
                                                            color: Colors.grey,
                                                            blurRadius: 15,
                                                          ),
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
                                                            Text(list[index]
                                                                    ["ID"]
                                                                .toString()),
                                                            Expanded(
                                                              // Растягиваем колонку по ширине
                                                              child: Column(
                                                                children: [
                                                                  Text(list[index]
                                                                          [
                                                                          "number_task"]
                                                                      .toString()),
                                                                  Text(list[
                                                                          index]
                                                                      ["name"]),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(list[
                                                                          index]
                                                                      [
                                                                      "percent"]
                                                                  .toString()),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "Статус"),
                                                                  Text(list[
                                                                          index]
                                                                      [
                                                                      "status"]),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  } else if (constraints
                                                          .maxWidth <
                                                      300) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                Offset(3, 3),
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
                                                            Expanded(
                                                              // Растягиваем колонку по ширине
                                                              child: Column(
                                                                children: [
                                                                  Text(list[index]
                                                                          [
                                                                          "number_task"]
                                                                      .toString()),
                                                                  Text(list[
                                                                          index]
                                                                      ["name"]),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                Offset(3, 3),
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
                                                            Expanded(
                                                              // Растягиваем колонку по ширине
                                                              child: Column(
                                                                children: [
                                                                  Text(list[index]
                                                                          [
                                                                          "number_task"]
                                                                      .toString()),
                                                                  Text(list[
                                                                          index]
                                                                      ["name"]),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Статус",
                                                                  ),
                                                                  Text(
                                                                    list[index][
                                                                        "status"],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              // child: Container(
                                              //   decoration: BoxDecoration(
                                              //     borderRadius:
                                              //         BorderRadius.circular(15),
                                              //     color: Colors.white,
                                              //     boxShadow: [
                                              //       BoxShadow(
                                              //         offset: Offset(3, 3),
                                              //         color: Colors.grey,
                                              //         blurRadius: 15,
                                              //       )
                                              //     ],
                                              //   ),
                                              //   width: double
                                              //       .infinity, // Контейнер занимает всю ширину
                                              //   child: Padding(
                                              //     padding: EdgeInsets.all(
                                              //       16.0,
                                              //     ),
                                              //     child: Row(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment
                                              //               .spaceBetween, // Разместить элементы равномерно
                                              //       children: [
                                              //         Text(list[index]["ID"]
                                              //             .toString()),
                                              //         Expanded(
                                              //           // Растягиваем колонку по ширине
                                              //           child: Column(
                                              //             children: [
                                              //               Text(list[index][
                                              //                       "number_task"]
                                              //                   .toString()),
                                              //               Text(list[index]
                                              //                   ["name"]),
                                              //             ],
                                              //           ),
                                              //         ),
                                              //         Expanded(
                                              //           child: Text(list[index]
                                              //                   ["percent"]
                                              //               .toString()),
                                              //         ),
                                              //         Expanded(
                                              //           child: Column(
                                              //             crossAxisAlignment:
                                              //                 CrossAxisAlignment
                                              //                     .start,
                                              //             children: [
                                              //               Text("Статус"),
                                              //               Text(list[index]
                                              //                   ["status"]),
                                              //             ],
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
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
                                    final taskInfo = state.task;
                                    return Center(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Сканирование: ${taskInfo.general_info.task_name}'),
                                              ElevatedButton(onPressed: (){
                                                context.read<ApiBloc>().add(DownloadPdf(taskNumber: taskInfo.general_info.task_number));
                                              }, child: Text("Скачать PDF отчёт"),),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedItem = null;
                                                    _selectedItemHosts = null;
                                                  });
                                                },
                                                icon: Icon(Icons.close),
                                              ),
                                            ],
                                          ),
                                          TabBar(
                                            tabs: [
                                              Tab(
                                                text: 'Информация',
                                                icon: Icon(Icons.info_outline),
                                              ),
                                              Tab(
                                                text: 'Отчёт по сканированию',
                                                icon: Icon(Icons.file_present),
                                              ),
                                              Tab(
                                                text: 'Дифференцирование',
                                                icon: Icon(Icons
                                                    .swap_horizontal_circle_outlined),
                                              )
                                            ],
                                            controller: _tabController,
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              controller: _tabController,
                                              children: [
                                                _buildGeneralInfo(
                                                    taskInfo.general_info,
                                                    taskInfo.hosts),

                                                ///SecondTab
                                                _buildHosts(taskInfo.hosts),

                                                ///ThirdTab
                                                _buildDiff(taskInfo.diff),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Scan:'),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedItem = null;
                                                    _selectedItemHosts = null;
                                                  });
                                                },
                                                icon: Icon(Icons.close),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Text('Error'),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfo(
      GeneralInfo generalInfo, Map<String, PentestHost> hosts) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsetsDirectional.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 2,
                color: Colors.blue,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Краткая информация: ${generalInfo.summary}',
                ),
                Divider(),
                Text(
                  'Время сканирования (сек): ${generalInfo.elapsed}',
                ),
                Text(
                  'Время начала: ${generalInfo.start}',
                ),
                Text(
                  'Время окончания: ${generalInfo.end}',
                ),
                Divider(),
                Text(
                  'Всего просканировано целей: ${generalInfo.total},',
                ),
                Text(
                  'Целей доступно: ${generalInfo.up}',
                ),
                Text(
                  'Целей недоступно: ${generalInfo.down}',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsetsDirectional.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 2,
                color: Colors.blue,
              ),
            ),
            child: Text(''),
          ),
        ],
      ),
    );
  }

  Widget _buildHosts(Map<String, PentestHost> hosts) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.blue),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: hosts.values.map((host) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('IP: ${host.ip}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Status: ${host.status}'),
                  Text('Ports:'),
                  ...host.ports.map((port) => Text(
                      '  - Port: ${port.port}, Protocol: ${port.protocol}, Service: ${port.service}, State: ${port.state}')),
                  SizedBox(height: 10),
                  ...host.vulns.values
                      .map((vuln) => _buildCollapsibleVuln(vuln)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsibleVuln(PentestVulns vuln) {
    return ExpansionTile(
      trailing: Text('${vuln.cvss}'),
      title:
          Text('ID: ${vuln.id}', style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Text('CPE: ${vuln.cpe}'),
        Text('CVSS: ${vuln.cvss}'),
        Text('CVSS Vector: ${vuln.cvss_vector}'),
        Text('CWE: ${vuln.cwe.join(", ")}'),
        Text('Description: ${vuln.description}'),
        Text('Port: ${vuln.port}'),
        Text('References: ${vuln.references}'),
        Text('Solutions: ${vuln.solutions}'),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildVuln(PentestVulns vuln) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('  - ID: ${vuln.id}',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text('    CPE: ${vuln.cpe}'),
        Text('    CVSS: ${vuln.cvss}'),
        Text('    CVSS Vector: ${vuln.cvss_vector}'),
        Text('    CWE: ${vuln.cwe.join(", ")}'),
        Text('    Description: ${vuln.description}'),
        Text('    Port: ${vuln.port}'),
        Text('    References: ${vuln.references}'),
        Text('    Solutions: ${vuln.solutions}'),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDiff(Map<String, PentestDiff> diff) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Добавлено',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: diff.entries.map((entry) {
                      String host = entry.key;
                      PentestDiff diffItem = entry.value;
                      return Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 2, color: Colors.blue),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Хост: $host',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Divider(),
                            ...diffItem.added.values
                                .map((vuln) => _buildCollapsibleVuln(vuln))
                                .toList(),
                            SizedBox(height: 20),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Убрано', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: diff.entries.map((entry) {
                      String host = entry.key;
                      PentestDiff diffItem = entry.value;
                      return Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 2, color: Colors.blue)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Хост: $host',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Divider(),
                            ...diffItem.removed.values
                                .map((vuln) => _buildCollapsibleVuln(vuln)),
                            SizedBox(height: 20),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
