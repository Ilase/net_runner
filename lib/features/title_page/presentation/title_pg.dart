import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/notificatioon_controller/notification_controller_cubit.dart';

class TitlePg extends StatefulWidget {
  const TitlePg({super.key});

  @override
  State<TitlePg> createState() => _TitlePgState();
}

class _TitlePgState extends State<TitlePg> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                )
              ]),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 2, color: Colors.blue)),
                          child: Placeholder(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 2, color: Colors.blue)),
                          child: Placeholder(),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: Colors.blue)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Уведомления'),
                                  ],
                                ),
                                Divider(),
                                Expanded(
                                  child: BlocBuilder<
                                      NotificationControllerCubit,
                                      NotificationControllerState>(
                                    builder: (builder, state) {
                                      if (state.notifications.isNotEmpty) {
                                        return ListView.builder(
                                          itemCount: state.notifications.length,
                                          itemBuilder: (builder, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color: Colors.blue,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state.notifications[index]
                                                          .title,
                                                    ),
                                                    Text(state
                                                        .notifications[index]
                                                        .body)
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        return Center(
                                          child: Text("Уведомлений нет"),
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2, color: Colors.blue)),
                    child: Placeholder(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
