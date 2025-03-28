import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/converters/statusConverter.dart';
import 'package:net_runner/core/data/converters/typeConverter.dart';
import 'package:net_runner/core/domain/api/api_bloc.dart';
import 'package:net_runner/core/domain/api/models/task/task_serial.dart';
import 'package:net_runner/core/domain/api/models/task_report_serial/networkscan/networkscan_report_serial.dart';
import 'package:net_runner/core/domain/host_list/host_list_cubit.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/utils/constants/themes/icons_by_cpe.dart';
import 'package:net_runner/utils/constants/themes/task_status_color.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

class HostCard extends StatelessWidget {
  final NetworkScanHost networkScanHost;
  final int index;

  final _addingNameController = TextEditingController();
  final _addingDescriptionController = TextEditingController();

  HostCard({
    super.key,
    required this.networkScanHost,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        front: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: AppTheme.lightTheme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: AppTextStyle.lightTextTheme.titleLarge,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Icon(
                            getIconForCPE(networkScanHost.cpe),
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<HostListCubit, HostListState>(
                            builder: (context, state) {
                          if (state is HostListFullState) {
                            if (state.list
                                .any((host) => host.ip == networkScanHost.ip)) {
                              return Text(
                                'Хост добавлен',
                                style: TextStyle(color: Colors.green),
                              );
                            }
                          }
                          return Text('Хост не добавлен');
                        }),
                        Text(
                          "Информация",
                          style: AppTextStyle.lightTextTheme.titleSmall,
                        ),
                        Text(
                          '${networkScanHost.os}',
                          style: AppTextStyle.lightTextTheme.titleSmall,
                        ),
                        Text(
                          '${networkScanHost.cpe}',
                          style: AppTextStyle.lightTextTheme.titleSmall,
                        ),
                        Text(
                          '${networkScanHost.ip}',
                          style: AppTextStyle.lightTextTheme.titleSmall,
                        ),
                        Text(
                          '${networkScanHost.mac}',
                          style: AppTextStyle.lightTextTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: AppTheme.lightTheme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Действия с хостом'),
                BlocBuilder<HostListCubit, HostListState>(
                  builder: (context, state) {
                    if (state is HostListFullState &&
                        state.list
                            .any((host) => host.ip == networkScanHost.ip)) {
                      return Text(
                        'Хост добавлен',
                        style: TextStyle(color: Colors.green),
                      );
                    } else {
                      return OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.8),
                            builder: (builder) {
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 500,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(networkScanHost.ip),
                                                  Icon(getIconForCPE(
                                                      networkScanHost.cpe)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller:
                                                    _addingNameController,
                                                decoration: InputDecoration(
                                                  label: Text("Имя хоста"),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller:
                                                    _addingDescriptionController,
                                                decoration: InputDecoration(
                                                  label: Text("Описание"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          context.read<ApiBloc>().add(
                                                PostHost(
                                                  body: {
                                                    "ip": networkScanHost.ip,
                                                    "name":
                                                        _addingNameController
                                                            .value.text,
                                                    "description":
                                                        _addingDescriptionController
                                                            .value.text,
                                                  },
                                                ),
                                              );
                                          _addingDescriptionController.clear();
                                          _addingNameController.clear();

                                          context
                                              .read<ApiBloc>()
                                              .add(GetHostListEvent());
                                          Navigator.of(context).pop();
                                        },
                                        label: Text("Подтвердить"),
                                        icon: Icon(Icons.check),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        label: Text('Добавить хост'),
                        icon: Icon(Icons.add),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final ModelTask task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          return Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: getTaskStatusColor(task.status),
                  width: 5,
                ),
              ),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                ),
              ],
            ),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(
                16.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(task.number_task.toString()),
                  ),
                  Expanded(
                    child: Text(
                      task.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (constraints.minWidth <= 600) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Прогресс  ${task.workingStatus ?? ""}'),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: LinearProgressIndicator(
                                      semanticsLabel: 'data',
                                      borderRadius: BorderRadius.circular(15),
                                      value: task.percent.toDouble(),
                                      minHeight: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text('${task.percent}%'),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Статус"),
                        Text(
                          statusConverter(task.status),
                          style: TextStyle(
                            color: getTaskStatusColor(task.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Тип"),
                        Text(typeConverter(task.type)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (constraints.maxWidth < 350) {
          return Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                  vertical: BorderSide(
                      color: getTaskStatusColor(task.status), width: 5)),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                ),
              ],
            ),
            width: double.infinity, // Контейнер занимает всю ширину
            child: Padding(
              padding: EdgeInsets.all(
                16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Разместить элементы равномерно
                children: [
                  Expanded(
                    // Растягиваем колонку по ширине
                    child: Column(
                      children: [
                        Text(task.number_task.toString()),
                        Text(
                          task.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: getTaskStatusColor(task.status),
                  width: 5,
                ),
              ),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.grey,
                  blurRadius: 15,
                ),
              ],
            ),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(task.number_task.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Статус",
                        ),
                        Text(
                          task.status,
                          style: TextStyle(
                            color: getTaskStatusColor(
                              task.status,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(task.type),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
