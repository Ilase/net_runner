import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/task_list/task_list_cubit.dart';
import 'package:net_runner/features/scanning/presentation/widgets/task_card.dart';
import 'package:net_runner/features/scanning/presentation/widgets/task_filter.dart';

import '../../../core/domain/api/models/task/task_serial.dart';

class TaskListPanel extends StatelessWidget {
  final ModelTask? selectedItem;
  final bool showFilter;
  final TextEditingController taskNameController;
  final TextEditingController typeController;
  final TextEditingController statusController;
  final TextEditingController numberTaskController;
  final VoidCallback onRefresh;
  final VoidCallback onSearch;
  final VoidCallback onToggleFilter;
  final VoidCallback onCreateScan;
  final Function(ModelTask) onTaskSelected;

  const TaskListPanel({
    super.key,
    required this.selectedItem,
    required this.showFilter,
    required this.taskNameController,
    required this.typeController,
    required this.statusController,
    required this.numberTaskController,
    required this.onRefresh,
    required this.onSearch,
    required this.onToggleFilter,
    required this.onCreateScan,
    required this.onTaskSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 400) return const SizedBox(width: 0);

        return Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(3, 3),
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
                  _buildHeader(),
                  const SizedBox(height: 8),
                  TaskFilter(
                    showFilter: showFilter,
                    typeController: typeController,
                    statusController: statusController,
                    numberTaskController: numberTaskController,
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Expanded(child: _buildTaskList()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
        Expanded(
          child: TextField(
            controller: taskNameController,
            decoration: const InputDecoration(labelText: 'Поиск'),
          ),
        ),
        IconButton(onPressed: onSearch, icon: const Icon(Icons.search)),
        IconButton(
          onPressed: onToggleFilter,
          icon: const Icon(Icons.filter_alt_rounded),
        ),
        IconButton(
          onPressed: onCreateScan,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return BlocBuilder<TaskListCubit, TaskListState>(
      builder: (context, state) {
        if (state is FilledState) {
          return ListView.builder(
            itemCount: state.list.length,
            itemBuilder: (context, index) {
              final task = state.list[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => onTaskSelected(task),
                  child: TaskCard(task: task),
                ),
              );
            },
          );
        } else if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(child: Text('ReloadList'));
      },
    );
  }
}
