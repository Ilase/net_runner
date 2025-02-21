import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';
import 'package:net_runner/features/scanning/presentation/widgets/scan_gesture_card.dart';

class ScanningPg extends StatefulWidget {
  const ScanningPg({super.key});

  @override
  State<ScanningPg> createState() => _ScanningPgState();
}

class _ScanningPgState extends State<ScanningPg> {
  Map<String, dynamic>? _selectedItem;
  List<dynamic>? _selectedItemHosts;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(3, 3),
              blurRadius: 10,
              color: Colors.grey,
            ),
          ],
        ),
        child: Column(
          children: [
            /// Поисковая строка
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      /// Перезагрузка списка
                      context.read<ApiBloc>().add(FetchTaskListEvent());
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
            ),

            /// Основное тело
            Expanded(
              child: Row(
                children: [
                  /// Левая панель (сканирования)
                  Expanded(
                    flex: _selectedItem == null
                        ? 7
                        : 10, // Расширяется, если нет выбранного элемента
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
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
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text('Сканирования*'),
                              SizedBox(height: 8),
                              Divider(),
                              SizedBox(height: 8),
                              Expanded(
                                child:
                                    BlocBuilder<TaskListCubit, TaskListState>(
                                  builder: (context, state) {
                                    if (state is FilledState) {
                                      final List<dynamic> list =
                                          state.list["taskList"];
                                      return Center(
                                        child: AnimatedList(
                                          reverse: true,
                                          initialItemCount: list.length,
                                          itemBuilder:
                                              (context, index, animation) {
                                            // Поправить ***
                                            // return ListTile(
                                            //   onTap: () {
                                            //     setState(() {
                                            //       _selectedItem = list[index];
                                            //       _selectedItemHosts = list[index]["hosts"];
                                            //     });
                                            //   },
                                            //   title: Text('Сканирование $index'),
                                            //   subtitle: Text(list[index]["name"]),
                                            //   trailing: Icon(Icons.arrow_forward),
                                            // );
                                            return SizedBox(
                                              width: double
                                                  .infinity, // Контейнер занимает всю ширину
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween, // Разместить элементы равномерно
                                                  children: [
                                                    Expanded(
                                                      // Растягиваем колонку по ширине
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              list[index]["ID"].toString()),
                                                          Text(list[index]
                                                              ["name"]),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Проценты'),
                                                          Text(list[index]
                                                                  ["percent"]
                                                              .toString()),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("Статус"),
                                                          Text(list[index]
                                                              ["status"]),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
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

                  /// Правая панель (подробности)
                  AnimatedContainer(
                    height: double.infinity,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: _selectedItem == null
                        ? 0
                        : MediaQuery.of(context).size.width * 0.7,
                    child: _selectedItem == null
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 16.0,
                              left: 16.0,
                              right: 16.0,
                              bottom: 16.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Группа: ${_selectedItem!["name"]}'),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ],
                                        ),
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
                                    Divider(),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Описание'),
                                          Text(
                                              '${_selectedItem!["description"]}'),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Хосты'),
                                    ),
                                    if (_selectedItemHosts != null &&
                                        _selectedItemHosts!.isNotEmpty)
                                      ..._selectedItemHosts!
                                          .map((host) => ListTile(
                                                title: Text(host["name"]),
                                                subtitle: Text(host["ip"]),
                                              )),
                                    if (_selectedItemHosts == null ||
                                        _selectedItemHosts!.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Хостов нет',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
