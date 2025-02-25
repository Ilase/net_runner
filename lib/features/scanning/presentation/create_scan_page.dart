import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/logger.dart';

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
                                label: 'Пентест',
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
                      onPressed: () {},
                      child: const Text('Подтвердить'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 8, right: 16),
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
                  children: [
                    Row(
                      children: [
                        const Text('Цели сканирования'),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    Divider(),
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
        const Text('Speed'),
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
                          labelText: 'Ports',
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
