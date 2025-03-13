import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/api/models/host/host_serial.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/ping_list/ping_list_cubit.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';
import 'package:net_runner/features/hosts/presentation/widgets/host_view/item_host_add.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class HostView extends StatefulWidget {
  const HostView({super.key});

  @override
  State<HostView> createState() => _HostViewState();
}

enum InfoModes { view, edit }

class _HostViewState extends State<HostView> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _rightListKey =
      GlobalKey<AnimatedListState>();
  List<HostItem> _rightList = [];
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
          TabBar(
            controller: _hostTabBar,
            isScrollable: false,
            indicatorPadding: EdgeInsets.all(8),
            indicatorAnimation: TabIndicatorAnimation.elastic,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: "Просмотр",
                icon: Icon(Icons.person_search),
              ),
              Tab(
                text: 'Добавление',
                icon: Icon(Icons.person_add),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _hostTabBar,
              children: [
                _buildHostView(),
                _buildHostAdd(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostView() {
    return Row(
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
                        icon: Icon(Icons.refresh),
                      ),
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
                    child: BlocBuilder<HostListCubit, HostListState>(
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

  Widget _buildHostAdd() {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.read<ApiBloc>().add(GetPingListEvent());
                              },
                              icon: Icon(Icons.refresh),
                            ),
                            Expanded(
                                child: TextField(
                              enabled: false,
                              decoration: InputDecoration(label: Text("Поиск")),
                            )),
                            IconButton(
                              onPressed: null, //TODO:make searchable
                              icon: Icon(Icons.search),
                            ),
                          ],
                        ),
                        Divider(),
                        Expanded(
                          child: BlocBuilder<PingListCubit, PingListState>(
                            builder: (builder, state) {
                              if (state is PingListFilledState) {
                                return ListView.builder(
                                  //TODO: make animated
                                  itemCount: state.list.length,
                                  itemBuilder: (builder, index) {
                                    final item = state.list[index];
                                    bool isAdded = _rightList
                                        .any((host) => host.ip == item);
                                    return ListTile(
                                      leading: Text((index + 1).toString()),
                                      title: Text(item),
                                      trailing: isAdded
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : Icon(Icons.arrow_forward),
                                      onTap: () {
                                        setState(() {
                                          if (!_rightList
                                              .any((host) => host.ip == item)) {
                                            _rightList.add(HostItem(item));
                                          } else {
                                            context
                                                .read<ApiBloc>()
                                                .notificationControllerCubit
                                                .addNotification(
                                                  "Уже добавлен",
                                                  "Хост уже добавлен",
                                                  NotificationType.warning,
                                                );
                                          }
                                        });
                                      },
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text("No ICMP hosts found"),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Добавленные хосты',
                              style: AppTextStyle.lightTextTheme.titleMedium,
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              label: Text('Подтвердить'),
                              iconAlignment: IconAlignment.end,
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        Expanded(
                          child: AnimatedBuilder(
                            animation: AnimationController(vsync: this),
                            builder: (context, animation) {
                              if (_rightList.isEmpty) {
                                return Center(
                                  child: Text('Выберите хосты для добавления'),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: _rightList.length,
                                  itemBuilder: (builder, index) {
                                    final item = _rightList[index];

                                    return Padding(
                                      padding: EdgeInsets.all(8),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(3, 3),
                                                blurRadius: 15,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        (index + 1).toString()),
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _rightList
                                                              .remove(item);
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        color: Colors.redAccent,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Text(item.ip),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: TextField(
                                                          decoration:
                                                              InputDecoration(
                                                            label: Text(
                                                                'Имя хоста'),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: TextField(
                                                          decoration:
                                                              InputDecoration(
                                                            label: Text(
                                                                'Описание'),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        // AnimatedList(itemBuilder: itemBuilder)
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
