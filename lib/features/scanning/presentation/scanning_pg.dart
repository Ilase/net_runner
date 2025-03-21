import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphic/graphic.dart';
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
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/utils/constants/themes/icons_by_cpe.dart';
import 'package:net_runner/utils/constants/themes/task_status_color.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';
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
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: double.minPositive);

  ///
  @override
  void initState() {
    super.initState();
    _pentestTabController = TabController(length: 3, vsync: this);
    _networkScanTabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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
                                        "name": _taskNameController.value.text,
                                        "type": _typeController.value.text,
                                        "status": _statusController.value.text,
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
                              return Center(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  reverse: false,
                                  itemCount: list.reversed.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
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
                                                  task_ID: list[index].ID,
                                                  task_type: list[index].type,
                                                ));
                                          }
                                        },
                                        child: TaskCard(task: list[index]),
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

  final Map<String, Color> severityColors = {
    'Незначительный': AppTheme.lightTheme.primaryColor,
    'Низкий': Colors.green,
    'Средний': Colors.orangeAccent,
    'Высокий': Colors.redAccent,
    'Критический': Colors.red.shade700,
  };
  String _getCategory(double cvssScore) {
    if (cvssScore >= 9.0 && cvssScore <= 10.0) {
      return 'Критический';
    } else if (cvssScore >= 7.0 && cvssScore <= 8.9) {
      return 'Высокий';
    } else if (cvssScore >= 4.0 && cvssScore <= 6.9) {
      return 'Средний';
    } else if (cvssScore >= 0.1 && cvssScore <= 3.9) {
      return 'Низкий';
    } else {
      return 'Незначительный';
    }
  }

  Widget _buildGeneralInfoPentest(
    GeneralInfo generalInfo,
    Map<String, PentestHost> hosts,
  ) {
    // List<Map<String, dynamic>> vulnsList = [];
    final Map<String, int> severityCount = {
      'Незначительный': 0,
      'Низкий': 0,
      'Средний': 0,
      'Высокий': 0,
      'Критический': 0,
    };
    for (var host in hosts.values) {
      for (var vuln in host.vulns.values) {
        double cvssScore = double.tryParse(vuln.cvss) ?? 0.0;

        if (cvssScore >= 9.0 && cvssScore <= 10.0) {
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

        //print('CVSS Score: $cvssScore, Category: ${_getCategory(cvssScore)}');
      }
    }
    final chartData = severityCount.entries
        .map((e) => {'severity': e.key, 'count': e.value})
        .toList();

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
        color: colors[entry.key] ?? AppTheme.lightTheme.primaryColor,
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
                color: AppTheme.lightTheme.primaryColor,
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
        Builder(builder: (context) {
          if (hosts.entries == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: AppTheme.lightTheme.primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Краткая сводка',
                        style: AppTextStyle.lightTextTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 300,
                            width: 300,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(),
                                sections: sections,
                                borderData: FlBorderData(show: true),
                                sectionsSpace: 1,
                                centerSpaceRadius: 40,
                              ),
                              duration: Duration(microseconds: 100),
                              curve: Curves.easeInOut,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Колличество угроз по уровню (CVSS3)'),
                                Text(
                                    'Незначительный: ${severityCount['Незначительный']}'),
                                Text('Низкий: ${severityCount['Низкий']}'),
                                Text('Средний: ${severityCount['Средний']}'),
                                Text('Высокий: ${severityCount['Высокий']}'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(
              child: Center(
                child: Text('Уязвимостей не найдено'),
              ),
            );
          }
        }),
      ],
    );
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
                color: AppTheme.lightTheme.primaryColor,
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
          //       color: AppTheme.lightTheme.primaryColor,
          //     ),
          //   ),
          //   child: Text(''),
          // ),
        ],
      ),
    );
  }

  Widget _buildHosts(Map<String, PentestHost> hosts) {
    if (hosts.isNotEmpty) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: hosts.values.map((host) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: AppTheme.lightTheme.primaryColor),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('IP: ${host.ip}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Статус: ${host.status}'),
                        Text('Порты:'),
                        ...host.ports.map(
                          (port) => ListTile(
                            title: Text('Порт: ${port.port}'),
                            subtitle: Text("Протокол: ${port.protocol}"),
                            leading: Icon(
                              port.state == "open"
                                  ? Icons.lock_open_outlined
                                  : Icons.lock_outline,
                              color: port.state == "open"
                                  ? Colors.green
                                  : Colors.redAccent,
                            ),
                            trailing: Text(
                              port.service,
                              style: AppTextStyle.lightTextTheme.bodyMedium,
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 10),
                        ...host.vulns.values.map(
                          (vuln) => _buildCollapsibleVuln(vuln),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    } else {
      return Center(
        child: Text('Нет хостов для отображения'),
      );
    }
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
                Text(
                  'Источник: ',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
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
      if (dCvss <= 0.1) {
        return Colors.grey;
      }
      if (dCvss >= 0.1 && dCvss <= 3.9) {
        return Colors.lightGreen;
      }
      if (dCvss >= 4.0 && dCvss <= 6.9) {
        return Colors.orangeAccent;
      }
      if (dCvss >= 7.0 && dCvss <= 8.9) {
        return Colors.redAccent;
      }
      if (dCvss >= 9.0 && dCvss <= 10.0) {
        return Colors.redAccent.shade700;
      }
    }
    return Colors.grey;
  }

  Widget _buildDiff(Map<String, PentestDiff> diff) {
    return Builder(builder: (context) {
      if (diff.isNotEmpty) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(),
                  height: 300,
                  child: Column(
                    children: [
                      Text('График диффиренцирования'),
                      SizedBox(
                        height: 200,
                        child: Scrollbar(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Placeholder();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...diff.entries.map(
                (entry) {
                  if (entry.value.prev_task == null) {
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: AppTheme.lightTheme.primaryColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Хост: ${entry.key}'),
                                  Text(
                                      'Дата последнего отчёта по хосту: ${entry.value.prev_task!.CreatedAt ?? "Not"}'),
                                ],
                              ),
                              Divider(),
                              SingleChildScrollView(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text('Добавлено'),
                                          SingleChildScrollView(
                                            child: Column(
                                              children: entry
                                                  .value.added.entries
                                                  .map((added) =>
                                                      _buildCollapsibleVuln(
                                                          added.value))
                                                  .toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text('Убрано'),
                                          SingleChildScrollView(
                                            child: Column(
                                              children: entry
                                                  .value.removed.entries
                                                  .map((removed) =>
                                                      _buildCollapsibleVuln(
                                                          removed.value))
                                                  .toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Text('Невозможно создать diff');
                  }
                },
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text('Нет диффиренцирования для данного сканирования'),
        );
      }
    });
  }

  Widget _buildTasksFilter() {
    return AnimatedContainer(
      height: _showFilter ? 150 : 0,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextField(
              controller: _numberTaskController,
              decoration: InputDecoration(
                label: Text("Номер задачи"),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text('Тип сканирования: '),
                    DropdownMenu(
                      onSelected: (value) {
                        _typeController.text = value!;
                      },
                      controller: _typeController,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: "pentest",
                          label: "Пентест",
                        ),
                        DropdownMenuEntry(
                          value: "networkscan",
                          label: "Просмотр сети",
                        ),
                        DropdownMenuEntry(
                          value: "agentInventory",
                          label: "Инвентаризация",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text('Статус сканирования: '),
                    DropdownMenu(
                      onSelected: (value) {
                        _statusController.text = value!;
                      },
                      controller: _statusController,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: "completed",
                          label: "Выполенено",
                          leadingIcon: Icon(Icons.check_circle_outline),
                        ),
                        DropdownMenuEntry(
                          value: "pending",
                          label: "Выполняется",
                          leadingIcon: Icon(Icons.radio),
                        ),
                        DropdownMenuEntry(
                          value: "error",
                          label: "Ошибка",
                          leadingIcon: Icon(Icons.error_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
                        ntLogger.t(taskInfo.diff.entries);
                        return Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${taskInfo.general_info.task_number} : ${taskInfo.general_info.task_name}',
                                    style:
                                        AppTextStyle.lightTextTheme.titleMedium,
                                  ),
                                  Row(
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          context.read<ApiBloc>().add(
                                                DownloadPdf(
                                                  type: _selectedItem!.type,
                                                  taskNumber: taskInfo
                                                      .general_info.task_number,
                                                ),
                                              );
                                        },
                                        child: Text("Скачать PDF"),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      OutlinedButton(
                                          onPressed: null,
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
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: _pentestTabController,
                                  children: [
                                    _buildGeneralInfoPentest(
                                      taskInfo.general_info,
                                      taskInfo.hosts,
                                    ),

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
          return HostCard(
            index: index,
            networkScanHost: hosts[index],
          );
        },
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      ),
    );
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
                                    child: Text('Посмотреть граф'),
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

class HostCard extends StatelessWidget {
  final NetworkScanHost networkScanHost;
  final int index;
  const HostCard({
    super.key,
    required this.networkScanHost,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: FlipCard(
        direction: FlipDirection.VERTICAL,
        front: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: AppTheme.lightTheme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.minWidth >= 250) {
                return Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: AppTextStyle.lightTextTheme.titleLarge,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Icon(
                                getIconForCPE(networkScanHost.cpe),
                                size: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Информация",
                              style: AppTextStyle.lightTextTheme.titleSmall,
                            ),
                            Text(
                              '${networkScanHost.os}',
                              style: AppTextStyle.lightTextTheme.titleSmall,
                            ),
                            Text(
                              '${networkScanHost.cpe}',
                              style: AppTextStyle.lightTextTheme.titleSmall,
                            ),
                            Text(
                              '${networkScanHost.ip}',
                              style: AppTextStyle.lightTextTheme.titleSmall,
                            ),
                            Text(
                              '${networkScanHost.mac}',
                              style: AppTextStyle.lightTextTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Icon(
                    getIconForCPE(networkScanHost.cpe),
                    size: 50,
                  ),
                );
              }
            }),
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: AppTheme.lightTheme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Действия с хостом'),
                OutlinedButton.icon(
                  onPressed: () {},
                  label: Text('Добавить в базу'),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final ModelTask task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          return Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: getTaskStatusColor(task.status),
                  width: 5,
                ),
              ),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                ),
              ],
            ),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(
                16.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(task.number_task.toString()),
                  ),
                  Expanded(
                    child: Text(
                      task.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (constraints.minWidth <= 600) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Прогресс'),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: LinearProgressIndicator(
                                      semanticsLabel: 'data',
                                      borderRadius: BorderRadius.circular(15),
                                      value: task.percent.toDouble(),
                                      minHeight: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text('${task.percent}%'),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Статус"),
                        Text(
                          task.status,
                          style:
                              TextStyle(color: getTaskStatusColor(task.status)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Тип"),
                        Text(task.type),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (constraints.maxWidth < 350) {
          return Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                  vertical: BorderSide(
                      color: getTaskStatusColor(task.status), width: 5)),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                ),
              ],
            ),
            width: double.infinity, // Контейнер занимает всю ширину
            child: Padding(
              padding: EdgeInsets.all(
                16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Разместить элементы равномерно
                children: [
                  Expanded(
                    // Растягиваем колонку по ширине
                    child: Column(
                      children: [
                        Text(task.number_task.toString()),
                        Text(
                          task.name,
                          overflow: TextOverflow.ellipsis,
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
                  color: getTaskStatusColor(task.status),
                  width: 5,
                ),
              ),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                ),
              ],
            ),
            width: double.infinity, // Контейнер занимает всю ширину
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Разместить элементы равномерно
                children: [
                  Expanded(
                    // Растягиваем колонку по ширине
                    child: Column(
                      children: [
                        Text(task.number_task.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Статус",
                        ),
                        Text(
                          task.status,
                          style: TextStyle(
                            color: getTaskStatusColor(
                              task.status,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(task.type),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
