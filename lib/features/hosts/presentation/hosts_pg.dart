import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/group_list/group_list_cubit.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';

class HostsPg extends StatefulWidget {
  const HostsPg({super.key});

  @override
  State<HostsPg> createState() => _HostsPgState();
}

class _HostsPgState extends State<HostsPg> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditingGroupMode = false;
  Map<String, dynamic>? _selectedItem;
  List<dynamic>? _selectedItemHosts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Группы'),
            Tab(text: 'Хосты'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGroupsView(context),
              _buildHostsView(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupsView(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
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
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.read<ApiBloc>().add(GetGroupListEvent());
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
                    SizedBox(height: 8),
                    Divider(),
                    SizedBox(height: 8),
                    Expanded(
                      child: BlocBuilder<GroupListCubit, GroupListState>(
                        builder: (context, state) {
                          if (state is FilledState) {
                            final List<dynamic> list = state.list["groupList"];
                            return ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      _selectedItem = list[index];
                                      _selectedItemHosts = list[index]["hosts"];
                                    });
                                  },
                                  title: Text(list[index]["name"]),
                                  trailing: Icon(Icons.arrow_forward),
                                );
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
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
        Expanded(
          child: _selectedItem != null
              ? _buildGroupDetailsView()
              : Center(child: Text('Выберите группу для просмотра')),
        ),
      ],
    );
  }

  Widget _buildGroupDetailsView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Группа: ${_selectedItem!["name"]}'),
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete, color: Colors.redAccent)),
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
            ],
          ),
          Divider(),
          Text('Описание: ${_selectedItem!["description"]}'),
          Divider(),
          Text('Хосты:'),
          Expanded(
            child: _selectedItemHosts != null && _selectedItemHosts!.isNotEmpty
                ? ListView.builder(
                    itemCount: _selectedItemHosts!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_selectedItemHosts![index]["name"]),
                        subtitle: Text(_selectedItemHosts![index]["ip"]),
                      );
                    },
                  )
                : Center(child: Text('Хостов нет')),
          ),
        ],
      ),
    );
  }

  Widget _buildHostsView(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
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
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
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
                      SizedBox(height: 8),
                      Divider(),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _selectedItem != null
                ? _buildGroupDetailsView()
                : Center(child: Text('Выберите хост для просмотра')),
          ),
        ],
      ),
    );
  }
}
