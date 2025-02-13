import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DatePicker extends StatefulWidget {
  final TextEditingController controller;
  final DateTime? initialDate;
  final String label;
  DatePicker({required this.controller, required this.label, this.initialDate});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime? selectedDate;
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

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
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
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context, widget.initialDate, widget.controller),
        ),
      ),
      inputFormatters: [_dateFormatter],
      keyboardType: TextInputType.number,
      onChanged: (text) {
        if (text.length == 10) {
          try {
            final date = DateFormat('dd.MM.yyyy').parse(text);
            setState(() {
              if (widget.controller == _startDateController) {
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
