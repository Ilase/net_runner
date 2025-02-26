import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/group_list/group_list_cubit.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';

class CreateScanPage extends StatefulWidget {
  const CreateScanPage({super.key});
  static const String route = '/create-scan';

  @override
  State<CreateScanPage> createState() => _CreateScanPageState();
}

class _CreateScanPageState extends State<CreateScanPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _portsController = TextEditingController();
  final TextEditingController _scanTypeController = TextEditingController();
  String? _selectedScanType;
  final Map<String, String> _scanTypeValues = {
    "pentest": "pentest",
    "networkscan": "networkscan"
  };

  List<dynamic> _groupList = [];
  List<dynamic> _hostList = [];

  double currentSliderValue = 1;

  List<String> portList = [];
  // List to keep track of selected IPs
  List<String> selectedIPs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новое задание'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 8),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    const BoxShadow(
                      offset: Offset(3, 3),
                      color: Colors.grey,
                      blurRadius: 15,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Настройки'),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.title),
                        labelText: 'Название',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Тип сканирования: '),
                        Expanded(
                          child: DropdownMenu(
                            onSelected: (value) {
                              setState(() {
                                _selectedScanType = value;
                              });
                            },
                            controller: _scanTypeController,
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                value: _scanTypeValues["pentest"],
                                label: 'pentest',
                              ),
                              DropdownMenuEntry(
                                value: _scanTypeValues["networkscan"],
                                label: 'Инвенторизация сети',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (_selectedScanType == _scanTypeValues["pentest"]) {
                            return _buildPentestVariant();
                          } else if (_selectedScanType == null) {
                            return Center(
                              child: Text('Выберите тип сканирования'),
                            );
                          } else {
                            return Center(
                              child: Text('В разработке'),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedScanType == _scanTypeValues["pentest"]) {
                          final String joinedPorts = portList.join(",");


                          List<String> _hostListIp = [];
                          for(final host in _hostList){
                            _hostListIp.add(host["ip"]);
                          }
                          List<String> _groupListIp = [];
                          for(final group in _groupList){
                            for(final host in group["hosts"]){
                              _groupListIp.add(host["ip"]);
                            }
                          }

                          List<String> _listIp = (_groupListIp + _hostListIp).toSet().toList();


                          context.read<ApiBloc>().add(
                                PostTask(
                                  body: {
                                    "name": _nameController.text,
                                    "hosts": _listIp,
                                    "type": _scanTypeValues["pentest"],
                                    "params": {
                                      "ports": joinedPorts,
                                      "speed": currentSliderValue.toInt().toString(),
                                    }
                                  },
                                ),
                              );
                        }
                        NotificationManager().showAnimatedNotification(context,
                            "Предупреждение", "Выберите тип сканирования");
                      },
                      child: const Text('Подтвердить'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    const BoxShadow(
                      offset: Offset(3, 3),
                      color: Colors.grey,
                      blurRadius: 15,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Группы'),
                        IconButton(
                          onPressed: () {
                            context.read<ApiBloc>().add(GetGroupListEvent());
                          },
                          icon: Icon(Icons.refresh),
                        )
                      ],
                    ),
                    Divider(),
                    Expanded(
                      child: BlocBuilder<GroupListCubit, GroupListState>(
                        builder: (context, state) {
                          if (state is FilledState) {
                            final List<dynamic> list = state.list["groupList"];
                            return ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (builder, index) {
                                  final item = list[index];
                                  final isSelected = _groupList.contains(item);
                                  return ListTile(
                                    onTap: (){
                                      setState(() {
                                        if (isSelected) {
                                          _groupList.remove(item);
                                        } else {
                                          _groupList.add(item);
                                        }
                                      });
                                    },
                                    title: Text(
                                        'Кол-во хостов: ${list[index]["hosts"].length}'),
                                    leading: Text(index.toString()),
                                    subtitle: Text(list[index]["name"]),
                                    trailing: Icon(
                                      isSelected ?  Icons.check : Icons.arrow_forward,
                                      color: isSelected ?  Colors.green : Colors.blue ,
                                    ),
                                  );
                                });
                          } else {
                            return Center(
                              child: Icon(Icons.error_outline),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    const BoxShadow(
                      offset: Offset(3, 3),
                      color: Colors.grey,
                      blurRadius: 15,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Хосты'),
                        IconButton(onPressed: () {
                          context.read<ApiBloc>().add(GetHostListEvent());
                        }, icon: Icon(Icons.refresh)),
                      ],
                    ),
                    Divider(),
                    Expanded(
                      child: BlocBuilder<HostListCubit, HostListState>(
                        builder: (context, state) {
                          if (state is FullState) {
                            final List<dynamic> list = state.list["hostList"];
                            return ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (builder, index) {
                                  final item = list[index];
                                  final bool isSelected = _hostList.contains(item);
                                  return ListTile(
                                    onTap: (){
                                      setState(() {
                                        if (isSelected) {
                                          _hostList.remove(item);
                                        } else {
                                          _hostList.add(item);
                                        }
                                      });
                                    },
                                    leading: Text(index.toString()),
                                    title: Text(list[index]["ip"]),
                                    subtitle: Text(list[index]["name"]),
                                    trailing: Icon(
                                      isSelected ?  Icons.check : Icons.arrow_forward,
                                      color: isSelected ? Colors.green : Colors.blue ,
                                    ),
                                  );
                                });
                          } else {
                            return Center(
                              child: Icon(Icons.error_outline),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPentestVariant() {
    return Column(
      children: [
        const Text(
            'Скорость сканирования (переместить на нужный уровень скорости [1-5])'),
        Slider(
          label: '${currentSliderValue.toInt()}',
          value: currentSliderValue,
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: (double value) {
            setState(
              () {
                currentSliderValue = value;
              },
            );
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          portList.clear();
                        });
                      },
                      icon: Icon(Icons.clear_all)),
                  Expanded(
                    child: TextField(
                      controller: _portsController,
                      decoration: const InputDecoration(
                          labelText: 'Порты',
                          hintText:
                              'Вводятся либо цельным числом либо через\'-\''),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          portList.add(_portsController.text);
                        });
                      },
                      icon: Icon(Icons.add_circle_outline))
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.grey),
                        BoxShadow(
                          spreadRadius: -1,
                          color: Colors.white,
                          blurRadius: 20,
                        ),
                      ]),
                  child: ListView.builder(
                    itemCount: portList.length,
                    itemBuilder: (builder, index) {
                      return ListTile(
                        subtitle: Text(portList[index]),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                portList.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.close)),
                      );
                    },
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
