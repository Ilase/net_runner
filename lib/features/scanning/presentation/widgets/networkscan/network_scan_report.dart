import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/api/models/task/task_serial.dart';
import 'package:net_runner/core/domain/api/models/task_report_serial/general_info.dart';
import 'package:net_runner/core/domain/api/models/task_report_serial/networkscan/networkscan_report_serial.dart';
import 'package:net_runner/core/domain/theme_controller/theme_controller_cubit.dart';
import 'package:net_runner/features/graph/presentation/graph_page.dart';
import 'package:net_runner/features/scanning/presentation/widgets/host_network_scan_card.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';
import 'package:net_runner/utils/routes/router.dart';

class NetworkScanReportWidget extends StatelessWidget {
  final ModelTask? selectedItem;
  final NetworkScanReport report;
  final VoidCallback onClose;

  const NetworkScanReportWidget({
    super.key,
    required this.selectedItem,
    required this.report,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: selectedItem == null ? 0 : MediaQuery.of(context).size.width * 0.7,
      child: selectedItem == null
          ? const SizedBox()
          : Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(3, 3),
                      blurRadius: 10,
                      color: Colors.grey,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        _buildHeader(context),
                        const TabBar(
                          tabs: [
                            Tab(
                                text: "Информация",
                                icon: Icon(Icons.info_outline)),
                            Tab(
                                text: "Хосты",
                                icon: Icon(Icons.group_outlined)),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildGeneralInfo(report.general_info, context),
                              _buildHostList(report.hosts),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${report.general_info.task_number} : ${report.general_info.task_name}',
          style: AppTextStyle.lightTextTheme.titleMedium,
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(createRoute(GraphPage(report: report)));
          },
          child: const Text('Посмотреть граф'),
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildGeneralInfo(GeneralInfo generalInfo, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 2,
                color: context.read<ThemeControllerCubit>().state.primaryColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Краткая информация: ${generalInfo.summary}'),
                const Divider(),
                Text('Время сканирования (сек): ${generalInfo.elapsed}'),
                Text('Время начала: ${generalInfo.start}'),
                Text('Время окончания: ${generalInfo.end}'),
                const Divider(),
                Text('Всего просканировано целей: ${generalInfo.total},'),
                Text('Целей доступно: ${generalInfo.up}'),
                Text('Целей недоступно: ${generalInfo.down}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHostList(List<NetworkScanHost> hosts) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: hosts.length,
        itemBuilder: (context, index) => HostCard(
          index: index,
          networkScanHost: hosts[index],
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.5,
        ),
      ),
    );
  }
}
