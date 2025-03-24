import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/api/models/group/group_serial.dart';
import 'package:net_runner/core/domain/api/models/host/host_serial.dart';
import 'package:net_runner/core/domain/group_list/group_list_cubit.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';
import 'package:net_runner/features/hosts/presentation/widgets/host_view/host_view.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class GroupView extends StatefulWidget {
  const GroupView({super.key});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> with TickerProviderStateMixin {
  TextEditingController _groupAddNameController = TextEditingController();
  TextEditingController _groupAddDescriptionController =
      TextEditingController();
  TextEditingController _editGroupNameController = TextEditingController();
  TextEditingController _editGroupDescriptionController =
      TextEditingController();

  late TabController _groupTabBar;
  InfoModes _viewMode = InfoModes.view;
  bool _showGroupFilter = false;

  List<ModelHost> _rightList = [];
  ModelGroup? _selectedItemForShowInfo;

  @override
  void initState() {
    super.initState();
    _groupTabBar = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _groupAddNameController.dispose();
    _groupAddDescriptionController.dispose();
    _editGroupNameController.dispose();
    _editGroupDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TabBar(
            controller: _groupTabBar,
            isScrollable: false,
            indicatorPadding: EdgeInsets.all(8),
            indicatorAnimation: TabIndicatorAnimation.elastic,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Просмотр", icon: Icon(Icons.person_search)),
              Tab(text: 'Добавление', icon: Icon(Icons.group_add)),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _groupTabBar,
              children: [
                _buildGroupView(),
                _buildGroupAdd(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupView() {
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
                        onPressed: () {
                          context.read<ApiBloc>().add(GetGroupListEvent());
                        },
                        icon: Icon(Icons.refresh),
                      ),
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(label: Text("Поиск")),
                      )),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showGroupFilter = !_showGroupFilter;
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
                    crossFadeState: _showGroupFilter
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 200),
                  ),
                  Divider(),
                  Expanded(
                    child: BlocBuilder<GroupListCubit, GroupListState>(
                      builder: (builder, state) {
                        if (state is GroupListFullState) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.list.length,
                            itemBuilder: (builder, index) {
                              final group = state.list[index];
                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    _selectedItemForShowInfo = group;
                                    _viewMode = InfoModes.view;
                                    _rightList.clear();
                                  });
                                },
                                title: Text(group.name),
                                trailing: Icon(Icons.arrow_forward),
                              );
                            },
                          );
                        } else if (state is GroupListLoadingState) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Center(child: Text("Групп нет"));
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
          child: Builder(builder: (builder) {
            if (_selectedItemForShowInfo != null) {
              return _buildGroupInfo();
            } else {
              return Center(child: Text("Выберите группу"));
            }
          }),
        ),
      ],
    );
  }

  Widget _buildGroupInfo() {
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
                      controller: _editGroupNameController,
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
                            _editGroupNameController.text =
                                _selectedItemForShowInfo!.name;
                            _editGroupDescriptionController.text =
                                _selectedItemForShowInfo!.description ?? "";
                            // Загружаем хосты группы в правый список для редактирования
                            _rightList = _selectedItemForShowInfo!.hosts ?? [];
                          } else {
                            _viewMode = InfoModes.view;
                            _editGroupNameController.clear();
                            _editGroupDescriptionController.clear();
                            _rightList.clear();
                          }
                        });
                      },
                      icon: Icon(_viewMode == InfoModes.edit
                          ? Icons.edit_off
                          : Icons.edit),
                    ),
                    AnimatedCrossFade(
                      firstChild: IconButton(
                        onPressed: () {
                          setState(() {
                            context.read<ApiBloc>().add(
                                DeleteGroup(id: _selectedItemForShowInfo!.ID));
                            context.read<ApiBloc>().add(GetGroupListEvent());
                            _selectedItemForShowInfo = null;
                            _rightList.clear();
                          });
                        },
                        icon:
                            Icon(Icons.delete_forever, color: Colors.redAccent),
                      ),
                      secondChild: IconButton(
                        onPressed: () {
                          // Сохраняем изменения
                          final List<Map<String, dynamic>> hosts = _rightList
                              .map((host) => {
                                    "ID": host.ID,
                                    "name": host.name,
                                    "ip": host.ip,
                                  })
                              .toList();

                          context.read<ApiBloc>().add(
                                PutGroup(
                                  groupId: _selectedItemForShowInfo!.ID,
                                  body: {
                                    "name": _editGroupNameController.text,
                                    "description":
                                        _editGroupDescriptionController.text,
                                    "hosts": hosts,
                                  },
                                ),
                              );

                          setState(() {
                            _viewMode = InfoModes.view;
                            _editGroupNameController.clear();
                            _editGroupDescriptionController.clear();
                          });
                        },
                        icon: Icon(Icons.check_circle_outline,
                            color: Colors.green),
                      ),
                      crossFadeState: _viewMode == InfoModes.view
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 200),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedItemForShowInfo = null;
                          _viewMode = InfoModes.view;
                          _rightList.clear();
                        });
                      },
                      icon: Icon(Icons.cancel_outlined),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            AnimatedCrossFade(
              firstChild: Text("${_selectedItemForShowInfo!.description}"),
              secondChild: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: _editGroupDescriptionController,
                  decoration: InputDecoration(label: Text("Описание")),
                ),
              ),
              crossFadeState: _viewMode == InfoModes.view
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 200),
            ),
            Divider(),
            Text("Хосты"),
            Expanded(
              child: AnimatedCrossFade(
                firstChild: _selectedItemForShowInfo!.hosts?.isEmpty ?? true
                    ? Center(child: Text("Нет хостов в группе"))
                    : ListView.builder(
                        itemCount: _selectedItemForShowInfo!.hosts?.length ?? 0,
                        itemBuilder: (builder, index) {
                          final host = _selectedItemForShowInfo!.hosts![index];
                          return ListTile(
                            title: Text(host.ip),
                            subtitle: Text(host.name),
                          );
                        },
                      ),
                secondChild: Container(
                  height: MediaQuery.of(context).size.height *
                      0.5, // Фиксированная высота
                  child: Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<HostListCubit, HostListState>(
                          builder: (context, state) {
                            if (state is HostListFullState) {
                              return ListView.builder(
                                itemCount: state.list.length,
                                itemBuilder: (builder, index) {
                                  final host = state.list[index];
                                  bool isSelected =
                                      _rightList.any((h) => h.ID == host.ID);
                                  return ListTile(
                                    title: Text(host.ip),
                                    subtitle: Text(host.name),
                                    trailing: IconButton(
                                      icon: Icon(
                                        isSelected ? Icons.check : Icons.add,
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.blue,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isSelected) {
                                            _rightList.removeWhere(
                                                (h) => h.ID == host.ID);
                                          } else {
                                            _rightList.add(host);
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            } else if (state is HostListLoadingState) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Center(child: Text("Нет доступных хостов"));
                          },
                        ),
                      ),
                      if (_rightList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Выбрано хостов: ${_rightList.length}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
                crossFadeState: _viewMode == InfoModes.view
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 200),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupAdd() {
    return Row(
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
                      onPressed: null,
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: BlocBuilder<HostListCubit, HostListState>(
                    builder: (builder, state) {
                      if (state is HostListFullState) {
                        return ListView.builder(
                          itemCount: state.list.length,
                          itemBuilder: (builder, index) {
                            final item = state.list[index];
                            bool isAdded =
                                _rightList.any((host) => host == item);
                            return ListTile(
                              leading: Text((index + 1).toString()),
                              title: Text(item.ip),
                              subtitle: Text(item.name),
                              trailing: isAdded
                                  ? Icon(Icons.check, color: Colors.green)
                                  : Icon(Icons.arrow_forward),
                              onTap: () {
                                setState(() {
                                  if (!_rightList.any((host) => host == item)) {
                                    _rightList.add(item);
                                  } else {
                                    context
                                        .read<ApiBloc>()
                                        .notificationControllerCubit
                                        .addNotification(
                                          "Уже выбран",
                                          "Хост уже выбран",
                                          NotificationType.warning,
                                        );
                                  }
                                });
                              },
                            );
                          },
                        );
                      } else {
                        return Center(child: Text("No ICMP hosts found"));
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Добавление группы'),
                    OutlinedButton.icon(
                      onPressed: () {
                        final List<Map<String, dynamic>> hosts = _rightList
                            .map((host) => {
                                  "ID": host.ID,
                                  "name": host.name,
                                  "ip": host.ip,
                                })
                            .toList();

                        context.read<ApiBloc>().add(
                              PostGroup(
                                body: {
                                  "name": _groupAddNameController.text,
                                  "description":
                                      _groupAddDescriptionController.text,
                                  "hosts": hosts
                                },
                              ),
                            );
                        setState(() {
                          _groupAddDescriptionController.clear();
                          _groupAddNameController.clear();
                          context.read<ApiBloc>().add(GetGroupListEvent());
                          _rightList.clear();
                        });
                      },
                      label: Text('Подтвердить'),
                      icon: Icon(Icons.check, color: Colors.green),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: _groupAddNameController,
                  decoration: InputDecoration(label: Text('Название группы')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: _groupAddDescriptionController,
                  decoration: InputDecoration(label: Text('Описание')),
                ),
              ),
              Divider(),
              Text('Хосты'),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        width: 2, color: Theme.of(context).primaryColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: _rightList.length,
                      itemBuilder: (builder, index) {
                        final item = _rightList[index];
                        return ListTile(
                          leading: Text((index + 1).toString()),
                          title: Text(item.ip),
                          subtitle: Text(item.name),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  _rightList.remove(item);
                                });
                              },
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: Colors.redAccent,
                              )),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
