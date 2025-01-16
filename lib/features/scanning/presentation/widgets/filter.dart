import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:net_runner/core/presentation/widgets/dropdown_field.dart';
import 'package:net_runner/core/presentation/widgets/date_picker.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class Filter extends StatefulWidget {
  final VoidCallback onClose;

  const Filter({super.key, required this.onClose});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final MaskTextInputFormatter _dateFormatter = MaskTextInputFormatter(
    mask: '##.##.####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  String? _selectedInterval;
  String? _selectedName;
  String? _selectedReportType;
  String? _selectedDataType;

  final List<String> _intervalOptions = ['Option 1', 'Option 2', 'Option 3'];
  final List<String> _nameOptions = ['Name 1', 'Name 2', 'Name 3'];
  final List<String> _reportTypeOptions = ['Report 1', 'Report 2', 'Report 3'];
  final List<String> _dataTypeOptions = ['Data 1', 'Data 2', 'Data 3'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Фильтры',
                style: AppTheme.lightTheme.textTheme.labelLarge,
              ),
            ),
            SizedBox(height: 25),
            DropdownField(
              label: 'Интервал',
              items: _intervalOptions,
              selectedValue: _selectedInterval,
              onChanged: (value) {
                setState(() {
                  _selectedInterval = value;
                });
              },
            ),
            DatePicker(
              context: context,
              controller: _startDateController,
              label: "Задание создано с",
              initialDate: _startDate,
            ),
            DatePicker(
              context: context,
              label: "По",
              controller: _endDateController,
              initialDate: _endDate,
            ),
            SizedBox(height: 20),
            DropdownField(
              label: 'Имя',
              items: _nameOptions,
              selectedValue: _selectedName,
              onChanged: (value) {
                setState(() {
                  _selectedName = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownField(
              label: 'Тип отчета',
              items: _reportTypeOptions,
              selectedValue: _selectedReportType,
              onChanged: (value) {
                setState(() {
                  _selectedReportType = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownField(
              label: 'Тип данных',
              items: _dataTypeOptions,
              selectedValue: _selectedDataType,
              onChanged: (value) {
                setState(() {
                  _selectedDataType = value;
                });
              },
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: widget.onClose,
                child: Text('Применить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
