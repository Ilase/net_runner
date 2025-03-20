import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';
import 'package:net_runner/core/domain/api/models/group/group_serial.dart';
import 'package:net_runner/core/domain/api/models/host/host_serial.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class MetricView extends StatefulWidget {
  const MetricView({super.key});

  @override
  State<MetricView> createState() => _MetricViewState();
}

class _MetricViewState extends State<MetricView> {
  final Graph metricGraph = Graph();
  FruchtermanReingoldAlgorithm algorithm = FruchtermanReingoldAlgorithm();
  final Map<int, Node> hostNodes = {};
  final Map<int, Node> groupNodes = {};
  List<ModelHost> hosts = [];
  Node? selectedNode;
  bool isSelectedNodeHost = false;

  @override
  void initState() {
    super.initState();
  }

  void _onNodeSelected(Node node) {
    setState(() {
      selectedNode = node;
      isSelectedNodeHost = hostNodes.containsKey((node.key as ValueKey).value);
    });
  }

  void _buildGraph(List<ModelHost> getHosts) {
    hosts = getHosts;

    for (var host in hosts) {
      Node hostNode = Node.Id(host.ID);
      metricGraph.addNode(hostNode);
      hostNodes[host.ID] = hostNode;

      if (host.Groups != null) {
        for (var group in host.Groups!) {
          if (!groupNodes.containsKey(group.ID)) {
            Node groupNode = Node.Id(group.ID);
            metricGraph.addNode(groupNode);
            groupNodes[group.ID] = groupNode;
          }
          metricGraph.addEdge(
            hostNodes[host.ID]!,
            groupNodes[group.ID]!,
            paint: Paint()
              ..color = Colors.black
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke,
          );
        }
      }
    }
  }

  Widget _nodeWidget(String title, bool isGroup) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isGroup ? Colors.black : Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    metricGraph.edges.clear();
    metricGraph.nodes.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HostListCubit, HostListState>(
      builder: (context, state) {
        if (state is HostListFullState) {
          if (metricGraph.nodes.isEmpty) _buildGraph(state.list);

          return Center(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: InteractiveViewer(
                    scaleEnabled: false,
                    constrained: false,
                    child: GraphView(
                      paint: Paint()
                        ..color = Colors.black
                        ..strokeWidth = 1
                        ..style = PaintingStyle.stroke
                        ..blendMode = BlendMode.exclusion
                        ..strokeCap = StrokeCap.butt,
                      graph: metricGraph,
                      algorithm: algorithm,
                      builder: (Node node) {
                        int id = (node.key as ValueKey).value;
                        String name = 'Unknown';
                        bool isHost = hostNodes.containsKey(id);

                        if (isHost) {
                          final host =
                              state.list.firstWhere((host) => host.ID == id);
                          name = host.name;
                        } else if (groupNodes.containsKey(id)) {
                          final group = state.list
                              .expand((host) => host.Groups ?? [])
                              .firstWhere((group) => group.ID == id);
                          name = group.name;
                        }

                        return GestureDetector(
                          onTap: () => _onNodeSelected(node),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isHost ? Colors.black : Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  isHost ? Icons.person : Icons.group,
                                  color: AppTheme.lightTheme.canvasColor,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(3, 3),
                            color: Colors.grey,
                            blurRadius: 15,
                          )
                        ],
                      ),
                      child: Builder(builder: (builder) {
                        if (selectedNode != null) {
                          int id = (selectedNode!.key as ValueKey).value;
                          if (isSelectedNodeHost) {
                            final host =
                                hosts.firstWhere((host) => host.ID == id);
                            return _buildHostInfo(host); // Виджет для хоста
                          } else {
                            final group = hosts
                                .expand((host) => host.Groups ?? [])
                                .firstWhere((group) => group.ID == id);
                            return _buildGroupInfo(group); // Виджет для группы
                          }
                        } else {
                          return Center(
                            child: Text('Выберите ноду'),
                          );
                        }
                      }),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(
            child: Text('Reload hosts'),
          );
        }
      },
    );
  }

  Widget _buildHostInfo(ModelHost host) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    host.name,
                    style: AppTextStyle.lightTextTheme.titleMedium,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        selectedNode = null;
                      });
                    },
                    icon: Icon(Icons.cancel_outlined)),
              ],
            ),
            Divider(),
            Text("IP ${host.ip}"),
            Text("${host.description}"),
            Divider(),
            Text("Инвентаризация"),
            Builder(builder: (builder) {
              if (host.inventory != null) {
                final inventory = host.inventory;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Время получания данных: ${host.UpdatedAt}'),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Имя хоста: ${inventory!.name}"),
                    Text("Операционная система: ${inventory.os}"),
                    Text("Версия системы: ${inventory.os_version}"),
                    Text("Полное имя ОС: ${inventory.full_os_name}"),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Версия ядра: ${inventory.kernel_version}"),
                    Text("Процессор: ${inventory.cpu_name}"),
                    Text("Кол-во ядер процессора: ${inventory.cpu_cores}"),
                    Text("Оперативная память: ${inventory.ram}"),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        "Время работы со времени сканирования: ${inventory.uptime}"),
                  ],
                );
              } else {
                return Text(
                  'Для данного хоста инвентаризация не проведена',
                  style: TextStyle(color: Colors.grey),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfo(ModelGroup group) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: AppTextStyle.lightTextTheme.titleMedium,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        selectedNode = null;
                      });
                    },
                    icon: Icon(Icons.cancel_outlined)),
              ],
            ),
            Divider(),
            Text(group.description),
            Divider(),
            Text("Хосты"),
            Text("Просмотр групп доступен только на вкладке \"Группы\""),
            // Expanded(
            //   child: Builder(builder: (builder) {
            //     if (group.hosts != null) {
            //       ntLogger.w(group.hosts!.isEmpty);
            //       return ListView.builder(
            //         itemCount: group.hosts!.length,
            //         itemBuilder: (builder, index) {
            //           final item = group.hosts![index];
            //           return ListTile(
            //             title: Text(item.ip),
            //             subtitle: Text(item.name),
            //           );
            //         },
            //       );
            //     } else {
            //       return Text(
            //         'Для данной группы нет хостов',
            //         style: TextStyle(color: Colors.grey),
            //       );
            //     }
            //   }),
            // ),
          ],
        ),
      ),
    );
  }
}
