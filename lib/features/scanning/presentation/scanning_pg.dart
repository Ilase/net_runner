import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphic/graphic.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/api/models/task/task_serial.dart';
import 'package:net_runner/core/domain/api/models/task_report_serial/general_info.dart';
import 'package:net_runner/core/domain/api/models/task_report_serial/networkscan/networkscan_report_serial.dart';
import 'package:net_runner/core/domain/api/models/task_report_serial/pentest/pentest_report_serial.dart';
import 'package:net_runner/core/domain/notificatioon_controller/notification_controller_cubit.dart';
import 'package:net_runner/core/domain/pentest_report_controller/pentest_report_controller_cubit.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';
import 'package:net_runner/features/graph/presentation/graph_page.dart';
import 'package:net_runner/features/scanning/presentation/create_scan_page.dart';
import 'package:net_runner/utils/constants/themes/task_status_color.dart';
import 'package:net_runner/utils/routes/router.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanningPg extends StatefulWidget {
  const ScanningPg({super.key});

  @override
  State<ScanningPg> createState() => _ScanningPgState();
}

class _ScanningPgState extends State<ScanningPg> with TickerProviderStateMixin {
  final heatmapChannel = StreamController<Selected?>.broadcast();
  ModelTask? _selectedItem;
  List<dynamic>? _selectedItemHosts;
  late TabController _pentestTabController;
  late TabController _networkScanTabController;
  bool _showFilter = false;

  ///
  TextEditingController _statusController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _numberTaskController = TextEditingController();
  TextEditingController _typeController = TextEditingController();

  ///
  @override
  void initState() {
    super.initState();
    _pentestTabController = TabController(length: 3, vsync: this);
    _networkScanTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pentestTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
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
                              context.read<ApiBloc>().add(FetchTaskListEvent());
                            },
                            icon: Icon(Icons.refresh),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _taskNameController,
                              decoration: InputDecoration(labelText: 'Поиск'),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<ApiBloc>().add(
                                    FetchTaskListEvent(
                                      queryParams: {
                                        "name": _taskNameController.text,
                                        "type": _typeController.value.text,
                                        "status": _statusController.text,
                                        //"status": ,
                                      },
                                    ),
                                  );
                            },
                            icon: Icon(Icons.search),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _showFilter = !_showFilter;
                                });
                              },
                              icon: Icon(Icons.filter_alt_rounded)),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(createRoute(CreateScanPage()));
                            },
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      _buildTasksFilter(),
                      SizedBox(height: 8),
                      Divider(),
                      SizedBox(height: 8),
                      Expanded(
                        child: BlocBuilder<TaskListCubit, TaskListState>(
                          builder: (context, state) {
                            if (state is FilledState) {
                              final List<ModelTask> list = state.list;
                              ntLogger.t(state.list.length + 1);
                              return Center(
                                child: ListView.builder(
                                  reverse: true,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // if();
                                            _selectedItem = list[index];
                                          });
                                          if (list[index].type ==
                                              "agentInventory") {
                                            _selectedItem = null;
                                            context
                                                .read<
                                                    NotificationControllerCubit>()
                                                .addNotification(
                                                    "Просмотр недоступен",
                                                    "Посмотреть ивенторизацию можно на странице \'Хосты\'",
                                                    NotificationType.warning);
                                          } else {
                                            context
                                                .read<ApiBloc>()
                                                .add(GetReport(
                                                  task_number:
                                                      list[index].number_task,
                                                  task_type: list[index].type,
                                                ));
                                          }
                                        },
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            if (constraints.maxWidth > 400) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border.symmetric(
                                                      vertical: BorderSide(
                                                          color:
                                                              getTaskStatusColor(
                                                                  list[index]
                                                                      .status),
                                                          width: 5)),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(3, 3),
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
                                                      Expanded(
                                                        child: Text(list[index]
                                                            .number_task
                                                            .toString()),
                                                      ),
                                                      Expanded(
                                                        // Растягиваем колонку по ширине
                                                        child: Text(
                                                          list[index].name,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            '${list[index].percent}%'
                                                                .toString()),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Статус"),
                                                            Text(
                                                              list[index]
                                                                  .status,
                                                              style: TextStyle(
                                                                  color: getTaskStatusColor(
                                                                      list[index]
                                                                          .status)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Тип"),
                                                            Text(list[index]
                                                                .type),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else if (constraints.maxWidth <
                                                350) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border.symmetric(
                                                      vertical: BorderSide(
                                                          color:
                                                              getTaskStatusColor(
                                                                  list[index]
                                                                      .status),
                                                          width: 5)),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(3, 3),
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
                                                      Expanded(
                                                        // Растягиваем колонку по ширине
                                                        child: Column(
                                                          children: [
                                                            Text(list[index]
                                                                .number_task
                                                                .toString()),
                                                            Text(
                                                              list[index].name,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
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
                                                  border: Border.symmetric(
                                                      vertical: BorderSide(
                                                          color:
                                                              getTaskStatusColor(
                                                                  list[index]
                                                                      .status),
                                                          width: 5)),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(3, 3),
                                                      color: Colors.grey,
                                                      blurRadius: 15,
                                                    ),
                                                  ],
                                                ),
                                                width: double
                                                    .infinity, // Контейнер занимает всю ширину
                                                child: Padding(
                                                  padding: EdgeInsets.all(16.0),
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
                                                                .number_task
                                                                .toString()),
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
                                                              list[index]
                                                                  .status,
                                                              style: TextStyle(
                                                                color:
                                                                    getTaskStatusColor(
                                                                  list[index]
                                                                      .status,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                              list[index]
                                                                  .type),),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else if (state is LoadingState) {
                              return Center(child: CircularProgressIndicator());
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

          BlocBuilder<ReportControllerCubit, ReportControllerState>(
            builder: (builder, state) {
              if (state is GetPentestTaskState) {
                return _buildPentestReport();
              } else if (state is GetNetworkScanTaskState) {
                return _buildNetworkScanReport();
              } else {
                return Center(
                  child: SizedBox(),
                );
              }
            },
          )

          /// Правая панель (подробности)
        ],
      ),
    );
  }

  Widget _buildGeneralInfoPentest(
    GeneralInfo generalInfo,
    Map<String, PentestHost> hosts,
  ) {
    // List<Map<String, dynamic>> vulnsList = [];
    final Map<String, int> severityCount = {
      'Критический': 0,
      'Высокий': 0,
      'Средний': 0,
      'Низкий': 0,
      'Незначительный': 0
    };
    for (var host in hosts.values) {
      for (var vuln in host.vulns.values) {
        double cvssScore = double.tryParse(vuln.cvss) ?? 0.0;

        if (cvssScore >= 9.0 && cvssScore >= 10) {
          severityCount['Критический'] = severityCount['Критический']! + 1;
        } else if (cvssScore >= 7.0 && cvssScore <= 8.9) {
          severityCount['Высокий'] = severityCount['Высокий']! + 1;
        } else if (cvssScore >= 4.0 && cvssScore <= 6.9) {
          severityCount['Средний'] = severityCount['Средний']! + 1;
        } else if (cvssScore >= 0.1 && cvssScore <= 3.9) {
          severityCount['Низкий'] = severityCount['Низкий']! + 1;
        } else {
          severityCount['Незначительный'] =
              severityCount['Незначительный']! + 1;
        }
      }
    }
    final chartData = severityCount.entries
        .map((e) => {'severity': e.key, 'count': e.value})
        .toList();

    ntLogger.w(chartData);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
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
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.blue),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Краткая сводка'),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 300,
                          maxHeight: 300,
                          maxWidth: 500,
                          minWidth: 400,
                        ),
                        // /height: double.maxFinite,
                        child: Chart(
                          data: chartData,
                          variables: {
                            'severity': Variable(
                              accessor: (Map map) => map['severity'] as String,
                            ),
                            'count': Variable(
                              accessor: (Map map) => map['count'] as num,
                            ),
                          },
                          marks: [
                            IntervalMark(
                              position: Varset('count') / Varset('severity'),
                              label: LabelEncode(
                                encoder: (tuple) => Label(
                                  tuple["severity"].toString(),
                                  LabelStyle(
                                    textStyle: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                              color: ColorEncode(
                                variable: 'severity',
                                values: [
                                  Colors.blue,
                                  Colors.green,
                                  Colors.orangeAccent,
                                  Colors.redAccent,
                                  Colors.red.shade700,
                                ],
                              ),
                              modifiers: [
                                StackModifier(),
                              ],
                            )
                          ],
                          coord: PolarCoord(
                            transposed: true,
                            dimCount: 1,
                            dimFill: 1.01,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Кол-во уязвимостей по уровню угрозы (CVSS)'),
                            Divider(),
                            Text('Незначительный: ${chartData[0]["count"]}'),
                            Text('Низкий: ${chartData[1]["count"]}'),
                            Text('Средний: ${chartData[2]["count"]}'),
                            Text('Высокий: ${chartData[3]["count"]}'),
                            Text('Кристический: ${chartData[4]["count"]}'),
                          ],
                        ),
                      )
                    ],
                  ),

                  ///example
                  // Container(
                  //   margin: const EdgeInsets.only(top: 10),
                  //   width: 350,
                  //   height: 300,
                  //   child: Chart(
                  //     data: basicData,
                  //     variables: {
                  //       'genre': Variable(
                  //         accessor: (Map map) => map['genre'] as String,
                  //       ),
                  //       'sold': Variable(
                  //         accessor: (Map map) => map['sold'] as num,
                  //       ),
                  //     },
                  //     transforms: [
                  //       Proportion(
                  //         variable: 'sold',
                  //         as: 'percent',
                  //       )
                  //     ],
                  //     marks: [
                  //       IntervalMark(
                  //         position: Varset('percent') / Varset('genre'),
                  //         label: LabelEncode(
                  //             encoder: (tuple) => Label(
                  //               tuple['sold'].toString(),
                  //             )),
                  //         color: ColorEncode(
                  //             variable: 'genre', values: Defaults.colors10),
                  //         modifiers: [StackModifier()],
                  //       )
                  //     ],
                  //     coord: PolarCoord(transposed: true, dimCount: 1, dimFill: 1.05),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       Expanded(
    //         child: Container(
    //           padding: EdgeInsetsDirectional.all(16),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(15),
    //             border: Border.all(
    //               width: 2,
    //               color: Colors.blue,
    //             ),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 'Краткая информация: ${generalInfo.summary}',
    //               ),
    //               Divider(),
    //               Text(
    //                 'Время сканирования (сек): ${generalInfo.elapsed}',
    //               ),
    //               Text(
    //                 'Время начала: ${generalInfo.start}',
    //               ),
    //               Text(
    //                 'Время окончания: ${generalInfo.end}',
    //               ),
    //               Divider(),
    //               Text(
    //                 'Всего просканировано целей: ${generalInfo.total},',
    //               ),
    //               Text(
    //                 'Целей доступно: ${generalInfo.up}',
    //               ),
    //               Text(
    //                 'Целей недоступно: ${generalInfo.down}',
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Expanded(child: Placeholder()),
    //     ],
    //   ),
    // );
  }

  Widget _buildGeneralInfoNetworkScan(
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
          // Container(
          //   padding: EdgeInsetsDirectional.all(16),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     border: Border.all(
          //       width: 2,
          //       color: Colors.blue,
          //     ),
          //   ),
          //   child: Text(''),
          // ),
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
    Uri refVulnUri = Uri.parse(vuln.references);

    return ExpansionTile(
      childrenPadding: EdgeInsets.all(8),
      controlAffinity: ListTileControlAffinity.leading,
      trailing: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Уровень угрозы: '),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: _getColorByCveCvss(vuln.cvss),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '${vuln.cvss}',
                  style: TextStyle(color: _getColorByCveCvss(vuln.cvss)),
                ),
              ),
            ),
          ],
        ),
      ),
      title: Text('${vuln.id}', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle:
          Text('${vuln.cpe}', style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CPE: ${vuln.cpe}'),
            Text('CVSS: ${vuln.cvss}'),
            Text('CVSS Vector: ${vuln.cvss_vector}'),
            Text('CWE: ${vuln.cwe.join(", ")}'),
            Text('Описание: ${vuln.description}'),
            Text('Порт: ${vuln.port}'),
            Row(
              children: [
                Text('Источник: '),
                InkWell(
                    onTap: () {
                      launchUrl(refVulnUri);
                    },
                    child: Text('${refVulnUri.host}')),
              ],
            ),
            Text('Решения: ${vuln.solutions}'),
            SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  Color _getColorByCveCvss(String cvss) {
    double? dCvss = double.tryParse(cvss);

    if (dCvss != null) {
      if (dCvss < 0.1) {
        return Colors.grey;
      }
      if (dCvss > 0.1 && dCvss < 3.9) {
        return Colors.lightGreen;
      }
      if (dCvss > 4.0 && dCvss < 6.9) {
        return Colors.orangeAccent;
      }
      if (dCvss > 7.0 && dCvss < 8.9) {
        return Colors.redAccent;
      }
      if (dCvss > 9.0 && dCvss < 10.0) {
        return Colors.redAccent.shade700;
      }
    }
    return Colors.grey;
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 8),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 2, color: Colors.blue),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Хост: $host',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Divider(),
                              ...diffItem.added.values
                                  .map((vuln) => _buildCollapsibleVuln(vuln))
                                  .toList(),
                              SizedBox(height: 20),
                            ],
                          ),
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
                    children: diff.entries.map(
                      (entry) {
                        String host = entry.key;
                        PentestDiff diffItem = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 8),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: Colors.blue)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Хост: $host',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Divider(),
                                ...diffItem.removed.values
                                    .map((vuln) => _buildCollapsibleVuln(vuln)),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTasksFilter() {
    return AnimatedContainer(
      height: _showFilter ? 200 : 0,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextField(
              controller: _statusController,
              decoration: InputDecoration(
                label: Text("Статус"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextField(
              controller: _numberTaskController,
              decoration: InputDecoration(
                label: Text("Номер задачи"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Text('Тип сканирования: '),
                DropdownMenu(
                  controller: _typeController,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                      value: "pentest",
                      label: "Пентест",
                    ),
                    DropdownMenuEntry(
                      value: "pentest",
                      label: "Просмотр сети",
                    ),
                    DropdownMenuEntry(
                      value: "pentest",
                      label: "Инвентаризация",
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPentestReport() {
    return AnimatedContainer(
      height: double.infinity,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width:
          _selectedItem == null ? 0 : MediaQuery.of(context).size.width * 0.7,
      child: _selectedItem == null
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
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
                  child:
                      BlocBuilder<ReportControllerCubit, ReportControllerState>(
                    builder: (context, state) {
                      if (state is LoadingTaskState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is GetPentestTaskState) {
                        final taskInfo = state.report;
                        return Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Сканирование: ${taskInfo.general_info.task_name}'),
                                  Row(
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          context.read<ApiBloc>().add(
                                              DownloadPdf(
                                                  type: _selectedItem!.type,
                                                  taskNumber: taskInfo
                                                      .general_info
                                                      .task_number));
                                        },
                                        child: Text("Скачать PDF"),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      OutlinedButton(
                                          onPressed: null,
                                          // onPressed: () {
                                          //   // context.read<ApiBloc>().add(
                                          //   //       OpenReportInBrowser(
                                          //   //         task_number: _selectedItem!
                                          //   //             .number_task,
                                          //   //         type: _selectedItem!.type,
                                          //   //       ),
                                          //   //     );
                                          // },
                                          child: Text('Открыть в браузере'))
                                    ],
                                  ),
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
                                    icon: Icon(
                                        Icons.swap_horizontal_circle_outlined),
                                  )
                                ],
                                controller: _pentestTabController,
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _pentestTabController,
                                  children: [
                                    _buildGeneralInfoPentest(
                                        taskInfo.general_info, taskInfo.hosts),

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
                              Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      // context.read<ApiBloc>().add(
                                      //     DownloadPdf(
                                      //         type: _selectedItem!.type,
                                      //         taskNumber: tas
                                      //             .general_info
                                      //             .task_number));
                                    },
                                    child: Text("Скачать PDF"),
                                  ),
                                  OutlinedButton(
                                      onPressed: () {},
                                      child: Text('Открыть в браузере'))
                                ],
                              ),
                              Divider(),
                              Center(child: Text('Error')),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHostListNetworkScanReport(List<NetworkScanHost> hosts) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: hosts.length,
        itemBuilder: (builder, index) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Хост: $index'),
                    Icon(
                      _getIconForCPE(hosts[index].cpe),
                      size: 50,
                      color: Colors.blue,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('IP: ${hosts[index].ip}'),
                        Text('MAC: ${hosts[index].mac}'),
                        Text('OS: ${hosts[index].os}'),
                        Text('CPE: ${hosts[index].cpe}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      ),
    );
  }

  IconData _getIconForCPE(String cpe) {
    if (cpe.contains("windows")) {
      return MaterialCommunityIcons.windows;
    }
    if (cpe.contains("linux")) {
      return MaterialCommunityIcons.linux;
    }
    if (cpe.contains("apple")) {
      return MaterialCommunityIcons.apple;
    }
    if (cpe.contains("dlink")) {
      return MaterialCommunityIcons.router_wireless;
    }
    if (cpe.contains("vmware")) {
      return FontAwesome5Icon.window_maximize;
    }
    if (cpe.contains("axis")) {
      return MaterialCommunityIcons.camera_gopro;
    }

    return Icons.device_unknown;
  }

  Widget _buildNetworkScanReport() {
    final TabController networkScanTabController =
        TabController(vsync: this, length: 2);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: double.infinity,
      width:
          _selectedItem == null ? 0 : MediaQuery.of(context).size.width * 0.7,
      child: _selectedItem == null
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
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
                  child:
                      BlocBuilder<ReportControllerCubit, ReportControllerState>(
                    builder: (context, state) {
                      if (state is LoadingTaskState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is GetNetworkScanTaskState) {
                        final taskInfo = state.report;
                        return Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Сканирование: ${taskInfo.general_info.task_name}'),
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(createRoute(
                                            GraphPage(report: state.report)));
                                      },
                                      child: Text('Посмотреть граф')),
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
                                  controller: _networkScanTabController,
                                  tabs: [
                                    Tab(
                                      text: "Информация",
                                      icon: Icon(Icons.info_outline),
                                    ),
                                    Tab(
                                      text: "Хосты",
                                      icon: Icon(Icons.group_outlined),
                                    )
                                  ]),
                              Expanded(
                                child: TabBarView(
                                  controller: _networkScanTabController,
                                  children: [
                                    _buildGeneralInfoNetworkScan(
                                      state.report.general_info,
                                      {},
                                    ),
                                    _buildHostListNetworkScanReport(
                                        state.report.hosts),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        ntLogger.e("${state.toString()}");
                        return Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Сканирование: ERROR'),
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
                              Center(
                                child: Text('Error'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
