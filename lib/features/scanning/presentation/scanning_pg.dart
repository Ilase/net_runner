import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/notificatioon_controller/notification_controller_cubit.dart';
import 'package:net_runner/core/domain/pentest_report_controller/pentest_report_controller_cubit.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';
import 'package:net_runner/features/scanning/presentation/create_scan_page.dart';
import 'package:net_runner/features/scanning/presentation/task_list.dart';
import 'package:net_runner/features/scanning/presentation/widgets/networkscan/network_scan_report.dart';
import 'package:net_runner/features/scanning/presentation/widgets/pentest/pentest_report.dart';
import 'package:net_runner/features/scanning/presentation/widgets/task_filter.dart';
import 'package:net_runner/utils/routes/router.dart';

import '../../../core/domain/api/models/task/task_serial.dart';
import '../../../core/presentation/widgets/notification_manager.dart';

class ScanningPg extends StatefulWidget {
  const ScanningPg({super.key});

  @override
  State<ScanningPg> createState() => _ScanningPgState();
}

class _ScanningPgState extends State<ScanningPg> with TickerProviderStateMixin {
  ModelTask? _selectedItem;
  bool _showFilter = false;
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _numberTaskController = TextEditingController();

  @override
  void dispose() {
    _taskNameController.dispose();
    _typeController.dispose();
    _statusController.dispose();
    _numberTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          // Left panel (task list)
          Expanded(
            flex: 1,
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth >= 400) {
                return TaskListPanel(
                  selectedItem: _selectedItem,
                  showFilter: _showFilter,
                  taskNameController: _taskNameController,
                  typeController: _typeController,
                  statusController: _statusController,
                  numberTaskController: _numberTaskController,
                  onRefresh: () =>
                      context.read<ApiBloc>().add(FetchTaskListEvent()),
                  onSearch: () => context.read<ApiBloc>().add(
                        FetchTaskListEvent(
                          queryParams: {
                            "name": _taskNameController.text,
                            "type": _typeController.text,
                            "status": _statusController.text,
                          },
                        ),
                      ),
                  onToggleFilter: () =>
                      setState(() => _showFilter = !_showFilter),
                  onCreateScan: () => Navigator.of(context)
                      .push(createRoute(const CreateScanPage())),
                  onTaskSelected: (task) {
                    setState(() => _selectedItem = task);
                    if (task.type == "agentInventory") {
                      setState(() => _selectedItem = null);
                      context
                          .read<NotificationControllerCubit>()
                          .addNotification(
                            "Просмотр недоступен",
                            "Посмотреть ивенторизацию можно на странице 'Хосты'",
                            NotificationType.warning,
                          );
                    } else {
                      context.read<ApiBloc>().add(
                            GetReport(
                              task_ID: task.ID,
                              task_type: task.type,
                            ),
                          );
                    }
                  },
                );
              } else {
                return Center(
                  child: Container(
                    child: Icon(Icons.emoji_emotions),
                  ),
                );
              }
            }),
          ),

          // Right panel (report view)
          Expanded(
            flex: 0,
            child: BlocBuilder<ReportControllerCubit, ReportControllerState>(
              builder: (context, state) {
                if (state is GetPentestTaskState) {
                  return PentestReportWidget(
                    selectedItem: _selectedItem,
                    report: state.report,
                    onClose: () => setState(() => _selectedItem = null),
                  );
                } else if (state is GetNetworkScanTaskState) {
                  return NetworkScanReportWidget(
                    selectedItem: _selectedItem,
                    report: state.report,
                    onClose: () => setState(() => _selectedItem = null),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
