import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:net_runner/features/hosts/presentation/widgets/group_view/group_view.dart';
import 'package:net_runner/features/hosts/presentation/widgets/host_view/host_view.dart';
import 'package:net_runner/features/hosts/presentation/widgets/metric_view/metric_view.dart';

class HostsPg extends StatefulWidget {
  const HostsPg({super.key});

  @override
  State<HostsPg> createState() => _HostsPgState();
}

class _HostsPgState extends State<HostsPg> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  final List<Widget> _tabs = [
    MetricView(),
    HostView(),
    GroupView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(3, 3),
              color: Colors.grey,
              blurRadius: 15,
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TabBar(
                isScrollable: false,
                indicatorPadding: EdgeInsets.all(8),
                indicatorAnimation: TabIndicatorAnimation.elastic,
                controller: _tabController,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: 'Сеть',
                    icon: Icon(MaterialCommunityIcons.grain),
                  ),
                  Tab(
                    text: 'Хосты',
                    icon: Icon(Icons.person),
                  ),
                  Tab(
                    text: 'Группы',
                    icon: Icon(Icons.groups),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: _tabs,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
