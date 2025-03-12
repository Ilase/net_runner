import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/api/models/host/host_serial.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class HostView extends StatefulWidget {
  const HostView({super.key});

  @override
  State<HostView> createState() => _HostViewState();
}

enum InfoModes { view, edit }

class _HostViewState extends State<HostView> with TickerProviderStateMixin {
  // late final AnimationController _infoBuilderController;
  late TabController _hostTabBar;
  InfoModes _viewMode = InfoModes.view;
  ModelHost? _selectedItemForShowInfo;
  bool _showHostFilter = false;

  @override
  void initState() {
    super.initState();
    _hostTabBar = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TabBar(controller: _hostTabBar, tabs: [
            Tab(
              text: "Просмотр",
            ),
            Tab(
              text: 'Добавление',
            )
          ]),
          Expanded(
            child: TabBarView(
              controller: _hostTabBar,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.refresh)),
                                  Expanded(
                                      child: TextField(
                                    decoration: InputDecoration(
                                      label: Text("Поиск"),
                                    ),
                                  )),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showHostFilter = !_showHostFilter;
                                      });
                                    },
                                    icon: Icon(Icons.filter_alt),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.search),
                                  )
                                ],
                              ),
                              AnimatedCrossFade(
                                firstCurve: Curves.easeInOut,
                                secondCurve: Curves.easeInOut,
                                reverseDuration: Duration(milliseconds: 100),
                                firstChild: SizedBox(),
                                secondChild: Container(
                                  child: Column(
                                    children: [
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(),
                                      ),
                                    ],
                                  ),
                                ),
                                crossFadeState: _showHostFilter
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
                              ),
                              Divider(),
                              Expanded(
                                child:
                                    BlocBuilder<HostListCubit, HostListState>(
                                  builder: (builder, state) {
                                    if (state is FullState) {
                                      return ListView.builder(
                                        itemCount: state.list.length,
                                        itemBuilder: (builder, index) {
                                          final host = state.list[index];
                                          return ListTile(
                                            onTap: () {
                                              setState(() {
                                                _selectedItemForShowInfo = host;
                                              });
                                            },
                                            leading: host.inventory == null
                                                ? Icon(Icons.circle_outlined)
                                                : Icon(Icons.inventory),
                                            title: Text(host.ip),
                                            subtitle: Text(host.name),
                                            trailing: Icon(Icons.arrow_forward),
                                          );
                                        },
                                      );
                                    } else {
                                      return Center(
                                        child: Text("Хостов нет"),
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: AnimatedBuilder(
                          animation: AnimationController(vsync: this),
                          builder: (builder, animation) {
                            if (_selectedItemForShowInfo != null) {
                              return _buildHostInfo();
                            } else {
                              return Center(
                                child: Text("Выберите хост"),
                              );
                            }
                          }),
                    ),
                    // VerticalDivider(),
                    // Expanded(flex: 1, child: _buildAddHost()),
                  ],
                ),
                Placeholder()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostInfo() {
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
                  child: AnimatedCrossFade(
                    firstChild: Text(
                      _selectedItemForShowInfo!.name,
                      style: AppTextStyle.lightTextTheme.titleMedium,
                    ),
                    secondChild: TextField(
                      decoration: InputDecoration(label: Text("Имя")),
                    ),
                    crossFadeState: _viewMode == InfoModes.view
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 200),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (_viewMode == InfoModes.view) {
                              _viewMode = InfoModes.edit;
                            } else {
                              _viewMode = InfoModes.view;
                            }
                          });
                        },
                        icon: Icon(_viewMode == InfoModes.edit
                            ? Icons.edit_off
                            : Icons.edit)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                        )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedItemForShowInfo = null;
                          });
                        },
                        icon: Icon(Icons.cancel_outlined)),
                  ],
                ),
              ],
            ),
            Divider(),
            AnimatedCrossFade(
              firstChild: Text("IP ${_selectedItemForShowInfo!.ip}"),
              secondChild: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  decoration: InputDecoration(label: Text("IP")),
                ),
              ),
              crossFadeState: _viewMode == InfoModes.view
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 200),
            ),
            AnimatedCrossFade(
              firstChild: Text("${_selectedItemForShowInfo!.description}"),
              secondChild: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  decoration: InputDecoration(label: Text("Описание")),
                ),
              ),
              crossFadeState: _viewMode == InfoModes.view
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 200),
            ),
            Divider(),
            Text("Инвентаризация"),
            Builder(builder: (builder) {
              if (_selectedItemForShowInfo!.inventory != null) {
                final inventory = _selectedItemForShowInfo!.inventory;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Время получания данных: ${_selectedItemForShowInfo!.UpdatedAt}'),
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

  Widget _buildAddHost() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Добавить хоста",
              style: AppTextStyle.lightTextTheme.titleMedium,
            ),
            Divider(),
            Expanded(child: Placeholder()),
            Expanded(child: Placeholder()),
          ],
        ),
      ),
    );
  }
}
