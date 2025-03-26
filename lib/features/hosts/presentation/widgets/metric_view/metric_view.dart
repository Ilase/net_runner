import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/force_graph/force_graph.dart';
import 'package:net_runner/core/domain/api/models/group/group_serial.dart';
import 'package:net_runner/core/domain/api/models/host/host_serial.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class MetricView extends StatefulWidget {
  const MetricView({super.key});

  @override
  State<MetricView> createState() => _MetricViewState();
}

class _MetricViewState extends State<MetricView> {
  final List<Node> hostNodes = [];
  final List<Edge> graphEdges = [];
  List<ModelHost> hosts = [];
  Node? selectedNode;
  bool isSelectedNodeHost = false;

  @override
  void initState() {
    super.initState();
  }

  // void _onNodeSelected(Node node) {
  //   setState(() {
  //     selectedNode = node;
  //     final keyValue = (node.key as ValueKey).value;
  //     isSelectedNodeHost = keyValue > 0;
  //   });
  // }

  void _buildGraph(List<ModelHost> getHosts) {
    hosts = getHosts;
    hostNodes.clear();
    graphEdges.clear();

    final Set<int> addedGroupIds = {};
    for (var host in hosts) {
      if (host.Groups != null) {
        for (final group in host.Groups!) {
          if (!addedGroupIds.contains(group.ID)) {
            final groupNode = Node(
              id: group.ID + 1000,
              position: Offset(
                  Random().nextDouble() * 200, Random().nextDouble() * 200),
              child: Container(
                decoration: BoxDecoration(color: Colors.blue),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(group.name),
                ),
              ),
            );
            hostNodes.add(groupNode);
            addedGroupIds.add(group.ID);
          }
        }
      }
    }

    for (var host in hosts) {
      Node hostNode = Node(
        id: host.ID,
        position:
            Offset(Random().nextDouble() * 200, Random().nextDouble() * 200),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(host.name),
          ),
        ),
      );
      hostNodes.add(hostNode);

      if (host.Groups != null) {
        for (final group in host.Groups!) {
          final groupIndex =
              hostNodes.indexWhere((node) => node.id == group.ID + 1000);
          if (groupIndex != -1) {
            graphEdges.add(
              Edge(fromId: host.ID, toId: group.ID + 1000),
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HostListCubit, HostListState>(
      builder: (context, state) {
        if (state is HostListFullState) {
          if (hostNodes.isEmpty) _buildGraph(state.list);
          return Center(
            child: Stack(
              children: [
                InteractiveViewer(
                  minScale: 0.1,
                  maxScale: 2,
                  child: ForceGraph(
                    nodes: hostNodes,
                    edges: graphEdges,
                    nodeRadius: 20,
                  ),
                ),
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
          ],
        ),
      ),
    );
  }
}
