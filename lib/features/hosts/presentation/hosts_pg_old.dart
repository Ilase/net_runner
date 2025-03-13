import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/ip_input_formatter.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/api/models/group/group_serial.dart';
import 'package:net_runner/core/domain/api/models/host/host_serial.dart';
import 'package:net_runner/core/domain/group_list/group_list_cubit.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/ping_list/ping_list_cubit.dart';

class HostsPgOld extends StatefulWidget {
  const HostsPgOld({super.key});

  @override
  State<HostsPgOld> createState() => _HostsPgOldState();
}

class _HostsPgOldState extends State<HostsPgOld>
    with SingleTickerProviderStateMixin {
  TextEditingController _ipEditingHostController = TextEditingController();
  TextEditingController _nameEditingHostController = TextEditingController();
  TextEditingController _descriptionEditingHostController =
      TextEditingController();

  late TabController _tabController;
  final TextEditingController _customIpController = TextEditingController();
  bool _isEditingGroupMode = false;
  ModelGroup? _selectedGroupItem;
  ModelHost? _selectedHostItem;
  List<Map<String, String>> _selectedHostsRightList = [];

  String hostTabState = "default";
  String groupTabState = "default";

  bool isHostEditing = false;

  List<ModelHost>? _selectedItemHosts;

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
              _buildGroupsView(),
              _buildHostsView(),
            ],
          ),
        ),
      ],
    );
  }

  /// Tab for groups
  Widget _buildGroupsView() {
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
                            enabled: true,
                            decoration: InputDecoration(labelText: 'Поиск'),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search),
                        ),
                        Divider(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              groupTabState = "adding";
                            });
                          },
                          icon: Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(),
                    SizedBox(height: 8),
                    Expanded(
                      child: Builder(builder: (context) {
                        return BlocBuilder<GroupListCubit, GroupListState>(
                          builder: (context, state) {
                            if (groupTabState != "adding") {
                              if (state is GroupListFullState &&
                                  state.list.isNotEmpty) {
                                final List<ModelGroup> list = state.list;
                                return ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {
                                        setState(
                                          () {
                                            _selectedGroupItem = list[index];
                                            _selectedItemHosts =
                                                list[index].hosts;
                                            groupTabState = "view";
                                          },
                                        );
                                      },
                                      title: Text(list[index].name),
                                      leading: Text((index + 1).toString()),
                                      subtitle: Text(
                                          "Кол-во хостов: ${list[index].hosts.length}"),
                                      trailing: Icon(Icons.arrow_forward),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text('Групп нет'),
                                );
                              }
                            } else {
                              return BlocBuilder<HostListCubit, HostListState>(
                                builder: (context, state) {
                                  if (state is HostListFullState) {
                                    return ListView.builder(
                                        itemCount: state.list.length,
                                        itemBuilder: (builder, index) {
                                          final item = state.list[index];
                                          bool isAdded = false;
                                          // final isAdded =
                                          //     _selectedGroupsRightList.any(
                                          //         (host) =>
                                          //             host["ip"] == ipAddress);
                                          return ListTile(
                                            leading: Text(item.ID.toString()),
                                            title: Text(item.ip),
                                            subtitle: Text(item.name),
                                            trailing: Icon(
                                              isAdded
                                                  ? Icons.check
                                                  : Icons.arrow_forward,
                                              color: isAdded
                                                  ? Colors.green
                                                  : Colors.blue,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                isAdded = !isAdded;
                                              });
                                            },
                                          );
                                        });
                                  } else {
                                    return Center(
                                      child: Text('Try to reload host list'),
                                    );
                                  }
                                },
                              );
                            }
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                )
              ],
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Builder(
              builder: (builder) {
                if (groupTabState == "adding") {
                  return _buildAddGroup();
                } else if (groupTabState == "view") {
                  return _buildGroupDetailsView();
                } else {
                  return Center(
                    child: Text('Выберите группу для просмотра'),
                  );
                }
              },
            ),
          ),
        )),
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
              Text('Группа: ${_selectedGroupItem!.name}'),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        groupTabState = "editing";
                      });
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                      onPressed: () {
                        context
                            .read<ApiBloc>()
                            .add(DeleteGroup(id: _selectedGroupItem!.ID));
                      },
                      icon: Icon(Icons.delete, color: Colors.redAccent)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedGroupItem = null;
                        _selectedItemHosts = null;
                        groupTabState = "default";
                      });
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ],
          ),
          Divider(),
          Text('Описание: ${_selectedGroupItem!.description}'),
          Divider(),
          Text('Хосты:'),
          Expanded(
            child: _selectedItemHosts != null && _selectedItemHosts!.isNotEmpty
                ? ListView.builder(
                    itemCount: _selectedItemHosts!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_selectedItemHosts![index].name),
                        subtitle: Text(_selectedItemHosts![index].ip),
                      );
                    },
                  )
                : Center(child: Text('Хостов нет')),
          ),
        ],
      ),
    );
  }

  Widget _buildHostsView() {
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
                            onPressed: () {
                              context.read<ApiBloc>().add(GetHostListEvent());
                            },
                            icon: Icon(Icons.refresh),
                          ),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(labelText: 'Поиск'),
                            ),
                          ),
                          IconButton(
                            onPressed: null,
                            icon: Icon(Icons.search),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<ApiBloc>().add(GetPingListEvent());
                              setState(() {
                                hostTabState = "adding";
                              });
                            },
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(),
                      SizedBox(height: 8),
                      Expanded(
                        child: BlocBuilder<HostListCubit, HostListState>(
                          builder: (context, state) {
                            if (hostTabState == "adding") {
                              return BlocBuilder<PingListCubit, PingListState>(
                                builder: (context, state) {
                                  if (state is PingListFilledState) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: _customIpController,
                                                decoration: InputDecoration(
                                                  label:
                                                      Text('Добавить вручную'),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedHostsRightList
                                                        .add({
                                                      "ip": _customIpController
                                                          .text,
                                                      "name": "",
                                                      "description": ""
                                                    });
                                                  });
                                                },
                                                icon:
                                                    Icon(Icons.arrow_forward)),
                                          ],
                                        ),
                                        Divider(),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: state.list.length,
                                            itemBuilder: (context, index) {
                                              final ipAddress =
                                                  state.list[index];
                                              final isAdded =
                                                  _selectedHostsRightList.any(
                                                      (host) =>
                                                          host["ip"] ==
                                                          ipAddress);
                                              return ListTile(
                                                leading: Text(index.toString()),
                                                subtitle: Text(ipAddress),
                                                trailing: isAdded
                                                    ? Icon(Icons.check,
                                                        color: Colors.green)
                                                    : Icon(Icons.arrow_forward),
                                                onTap: isAdded
                                                    ? () {
                                                        setState(() {
                                                          _selectedHostsRightList
                                                              .removeWhere(
                                                                  (item) =>
                                                                      item[
                                                                          "ip"] ==
                                                                      ipAddress);
                                                        });
                                                      }
                                                    : () {
                                                        setState(() {
                                                          _selectedHostsRightList
                                                              .add({
                                                            "ip": ipAddress,
                                                            "name": "",
                                                            "description": ""
                                                          });
                                                        });
                                                      },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              );
                            } else {
                              if (state is HostListFullState) {
                                final List<ModelHost> list = state.list;
                                return ListView.builder(
                                    itemCount: list.length,
                                    itemBuilder: (builder, index) {
                                      return ListTile(
                                        onTap: () {
                                          setState(() {
                                            _selectedHostItem = list[index];
                                            hostTabState = "view";
                                          });
                                        },
                                        title: Text(
                                          list[index].ip,
                                        ),
                                        subtitle: Text(
                                          list[index].name,
                                        ),
                                        leading: list[index].inventory != null
                                            ? Icon(
                                                Icons.inventory,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.circle_outlined,
                                                color: Colors.blue,
                                              ),
                                        trailing: Icon(Icons.arrow_forward),
                                      );
                                    });
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
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
                        color: Colors.grey,
                        blurRadius: 15),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Builder(
                    builder: (builder) {
                      if (hostTabState == "view") {
                        return _buildHostDetails();
                      } else if (hostTabState == "adding") {
                        return _buildAddHost();
                      } else {
                        return Center(
                          child: Text('Выберите хост для просмотра'),
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
    );
  }

  Widget _buildAddHost() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Добавить хосты",
              style: TextStyle(
                fontSize: 38,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  hostTabState = "default";
                });
              },
              icon: Icon(Icons.close),
            )
          ],
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: _selectedHostsRightList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_selectedHostsRightList[index]["ip"]}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedHostsRightList.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    TextField(
                      decoration: InputDecoration(labelText: "Имя"),
                      onChanged: (value) {
                        setState(() {
                          _selectedHostsRightList[index]["name"] = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(labelText: "Описание"),
                      onChanged: (value) {
                        setState(() {
                          _selectedHostsRightList[index]["description"] = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            for (dynamic item in _selectedHostsRightList) {
              context.read<ApiBloc>().add(
                    PostHost(
                      body: {
                        "ip": item["ip"],
                        "name": item["name"],
                        "description": item["description"],
                      },
                    ),
                  );
            }
            setState(() {
              _selectedHostsRightList.clear();
            });
          },
          child: Text('Добваить'),
        ),
      ],
    );
  }

  Widget _buildAddGroup() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Добавить группу',
                style: TextStyle(
                  fontSize: 38,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    groupTabState = "default";
                  });
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _buildHostDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Builder(
                builder: (builder) {
                  _nameEditingHostController.text = _selectedHostItem!.name;
                  if (isHostEditing) {
                    return Row(
                      children: [
                        Text("Хост: "),
                        Expanded(
                            child: TextField(
                          controller: _nameEditingHostController,
                        )),
                      ],
                    );
                  } else {
                    return Text('Хост: ${_selectedHostItem!.name}');
                  }
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isHostEditing = !isHostEditing;
                      if (!isHostEditing) {
                        _descriptionEditingHostController.clear();
                        _ipEditingHostController.clear();
                        _nameEditingHostController.clear();
                      }
                    });
                  },
                  icon: Icon(isHostEditing ? Icons.edit_off : Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    context
                        .read<ApiBloc>()
                        .add(DeleteHost(id: _selectedHostItem!.ID));
                  },
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      hostTabState = "default";
                      isHostEditing = false;
                    });
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ],
        ),
        Divider(),
        Builder(
          builder: (builder) {
            if (isHostEditing) {
              _ipEditingHostController.text = _selectedHostItem!.ip;
              return Row(
                children: [
                  Text("IP: "),
                  Expanded(
                      child: TextField(
                    controller: _ipEditingHostController,
                    inputFormatters: [
                      IPTextInputFormatter(),
                    ],
                  )),
                ],
              );
            } else {
              return Text('IP: ${_selectedHostItem!.ip}');
            }
          },
        ),
        Divider(),
        Text('Описание'),
        Builder(
          builder: (builder) {
            if (isHostEditing) {
              _descriptionEditingHostController.text =
                  _selectedHostItem!.description ?? "";
              return TextField(
                controller: _descriptionEditingHostController,
              );
            } else {
              return Text('${_selectedHostItem!.description}');
            }
          },
        ),
        Divider(),
        Builder(builder: (builder) {
          if (isHostEditing) {
            return ElevatedButton(
                onPressed: () {
                  context.read<ApiBloc>().add(
                        PutHost(
                          hostId: _selectedHostItem!.ID,
                          body: {
                            "name": _nameEditingHostController.text,
                            "ip": _ipEditingHostController.text,
                            "description":
                                _descriptionEditingHostController.text
                          },
                        ),
                      );
                },
                child: Text('Подтвердить'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Инвентаризация'),
                Builder(builder: (builder) {
                  if (_selectedHostItem!.inventory != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Время актуализации: ${_selectedHostItem!.UpdatedAt}'),
                        Text(
                            'Имя хоста: ' + _selectedHostItem!.inventory!.name),
                        Text('OS: ' + _selectedHostItem!.inventory!.os),
                        Text('Версия OS: ' +
                            _selectedHostItem!.inventory!.os_version),
                        Text('Версия ядра: ' +
                            _selectedHostItem!.inventory!.kernel_version),
                        Text('Полное название OS: ' +
                            _selectedHostItem!.inventory!.full_os_name),
                        Text('Процессор: ' +
                            _selectedHostItem!.inventory!.cpu_name),
                        Text('Кол-во ядер: ' +
                            _selectedHostItem!.inventory!.cpu_cores.toString()),
                        Text('Кол-во ОЗУ: ' +
                            _selectedHostItem!.inventory!.ram.toString()),
                        Text('Время работы: ' +
                            _selectedHostItem!.inventory!.uptime.toString()),
                      ],
                    );
                  } else {
                    return Text(
                      'Нет инвенторизации на данный хост',
                      style: TextStyle(color: Colors.grey),
                    );
                  }
                }),
              ],
            );
          }
        }),
      ],
    );
  }
}
