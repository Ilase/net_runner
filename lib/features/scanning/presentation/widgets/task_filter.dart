import 'package:flutter/material.dart';

class TaskFilter extends StatelessWidget {
  final bool showFilter;
  final TextEditingController typeController;
  final TextEditingController statusController;
  final TextEditingController numberTaskController;

  const TaskFilter({
    super.key,
    required this.showFilter,
    required this.typeController,
    required this.statusController,
    required this.numberTaskController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: showFilter ? 150 : 0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextField(
              controller: numberTaskController,
              decoration: const InputDecoration(label: Text("Номер задачи")),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTypeDropdown(),
              _buildStatusDropdown(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Text('Тип сканирования: '),
          DropdownMenu(
            onSelected: (value) => typeController.text = value!,
            controller: typeController,
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: "pentest", label: "Пентест"),
              DropdownMenuEntry(value: "networkscan", label: "Просмотр сети"),
              DropdownMenuEntry(
                  value: "agentInventory", label: "Инвентаризация"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Text('Статус сканирования: '),
          DropdownMenu(
            onSelected: (value) => statusController.text = value!,
            controller: statusController,
            dropdownMenuEntries: const [
              DropdownMenuEntry(
                value: "completed",
                label: "Выполенено",
                leadingIcon: Icon(Icons.check_circle_outline),
              ),
              DropdownMenuEntry(
                value: "pending",
                label: "Выполняется",
                leadingIcon: Icon(Icons.radio),
              ),
              DropdownMenuEntry(
                value: "error",
                label: "Ошибка",
                leadingIcon: Icon(Icons.error_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
