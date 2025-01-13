// import 'package:flutter/material.dart';
// import 'package:net_runner/utils/constants/themes/app_themes.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Filter',
//       theme: ThemeData(
//       ),
//       home: Filters(),
//     );
//   }
// }
//
// class Filters extends StatefulWidget {
//   const Filters({super.key});
//
//   @override
//   State<Filters> createState() => _FiltersState();
// }
//
// class _FiltersState extends State<Filters> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FilterScreen(),
    );
  }
}

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
    if (_isDrawerOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Основной контент
        Scaffold(
          appBar: AppBar(
            title: Text('Фильтры'),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: _toggleDrawer,
              child: Text('Применить фильтры'),
            ),
          ),
        ),
        // Выдвижное меню
        AnimatedBuilder(
          animation: _offsetAnimation,
          builder: (context, child) {
            return Align(
              alignment: Alignment.centerRight,
              child: SlideTransition(
                position: _offsetAnimation,
                child: child,
              ),
            );
          },
          child: FilterWidget(
            onClose: _toggleDrawer,
          ),
        ),
      ],
    );
  }
}

class FilterWidget extends StatefulWidget {
  final VoidCallback onClose;

  FilterWidget({required this.onClose});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final MaskTextInputFormatter _dateFormatter = MaskTextInputFormatter(
    mask: '##.##.####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final List<String> _intervalOptions = ['Сегодня', 'Неделя', 'Месяц', 'Год'];
  final List<String> _nameOptions = ['Имя 1', 'Имя 2', 'Имя 3'];
  final List<String> _reportTypeOptions = ['Тип 1', 'Тип 2', 'Тип 3'];
  final List<String> _dataTypeOptions = ['Данные 1', 'Данные 2', 'Данные 3'];

  String? _selectedInterval;
  String? _selectedName;
  String? _selectedReportType;
  String? _selectedDataType;

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd.MM.yyyy').format(picked);
        if (initialDate == _startDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      child: Container(
        width: 300, // Уменьшаем ширину контейнера
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          //spacing: ,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
              'Фильтры',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ),
            SizedBox(height: 25),
            _buildDropdownField(context, 'Интервал', _intervalOptions, _selectedInterval, (value) {
              setState(() {
                _selectedInterval = value;
              });
            }),
            _buildDatePicker(context, 'Задание создано с', _startDateController, _startDate),
            _buildDatePicker(context, 'По', _endDateController, _endDate),
            SizedBox(height: 20),
            _buildDropdownField(context, 'Имя', _nameOptions, _selectedName, (value) {
              setState(() {
                _selectedName = value;
              });
            }),
            SizedBox(height: 20),
            _buildDropdownField(context, 'Тип отчета', _reportTypeOptions, _selectedReportType, (value) {
              setState(() {
                _selectedReportType = value;
              });
            }),
            SizedBox(height: 20),
            _buildDropdownField(context, 'Тип данных', _dataTypeOptions, _selectedDataType, (value) {
              setState(() {
                _selectedDataType = value;
              });
            }),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
              onPressed: widget.onClose,
              child: Text('Применить фильтры'),
            ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context, String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButtonFormField<String>(
          value: selectedValue,
          hint: Text('Выберите $label'),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, String label, TextEditingController controller, DateTime? initialDate) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context, initialDate, controller),
        ),
      ),
      inputFormatters: [_dateFormatter],
      keyboardType: TextInputType.number,
      onChanged: (text) {
        if (text.length == 10) {
          try {
            final date = DateFormat('dd.MM.yyyy').parse(text);
            setState(() {
              if (controller == _startDateController) {
                _startDate = date;
              } else {
                _endDate = date;
              }
            });
          } catch (e) {
          }
        }
      },
    );
  }
}
