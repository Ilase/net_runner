import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class DatePicker extends StatefulWidget {
  final TextEditingController controller;
  final DateTime? initialDate;

  DatePicker({required this.controller, this.initialDate});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: AppTheme.lightTheme.textTheme.labelMedium,
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
      onTap: () => _selectDate(context),
    );
  }
}
