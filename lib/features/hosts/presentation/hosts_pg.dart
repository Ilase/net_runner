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

class _HostsPgState extends State<HostsPg> {
  Map<String, dynamic>? _selectedItem;
  List<dynamic>? _selectedItemHosts;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
<<<<<<< HEAD
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         color: Colors.white,
          //         boxShadow: [
          //           BoxShadow(
          //             offset: Offset(3, 3),
          //             blurRadius: 10,
          //             color: Colors.grey,
          //           ),
          //         ]),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text('Хосты и группы'),
          //     ),
          //   ),
          // ),
=======
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(3, 3),
                    blurRadius: 10,
                    color: Colors.grey,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Хосты и группы'),
              ),
            ),
          ),
>>>>>>> 7db0ed4 (Update scanning view state)
          Expanded(
            child: Row(
              children: [
                Expanded(
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
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<ApiBloc>()
                                        .add(GetGroupListEvent());
                                  },
                                  icon: Icon(Icons.refresh),
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration:
                                        InputDecoration(labelText: 'Поиск'),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.search),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Divider(),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child:
                                  BlocBuilder<GroupListCubit, GroupListState>(
                                builder: (builder, state) {
                                  if (state is FilledState) {
                                    final List<dynamic> list =
                                        state.list["groupList"];
                                    return Center(
                                      child: AnimatedList(
                                        initialItemCount: list.length,
                                        itemBuilder:
                                            (context, index, animation) {
                                          return ListTile(
                                            onTap: () {
                                              setState(() {
                                                _selectedItem = list[index];
                                                _selectedItemHosts =
                                                    list[index]["hosts"];
                                              });
                                            },
                                            title: Text('$index'),
                                            subtitle: Text(list[index]["name"]),
                                            trailing: Icon(Icons.arrow_forward),
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return Expanded(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
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
                ),
                Expanded(
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
                      child: Builder(builder: (builder) {
                        if (_selectedItem != null) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Группа: ${_selectedItem!["name"]}',
                                    ),
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
                                      Text('${_selectedItem!["description"]}'),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Хосты'),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _selectedItemHosts!.length,
                                    itemBuilder: (builder, index) {
                                      if (_selectedItemHosts!.isNotEmpty) {
                                        return ListTile(
                                          title: Text(
                                            _selectedItemHosts![index]["name"],
                                          ),
                                          subtitle: Text(
                                              _selectedItemHosts![index]["ip"]),
                                        );
                                      } else {
                                        return Center(
                                          child: Text('Хостов нет'),
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Text('Выберете группу для просмотра'),
                          );
                        }
                      }),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
