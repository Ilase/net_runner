import 'package:flutter/material.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';

class DropdownField extends StatefulWidget {
  final String label;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const DropdownField({
    super.key,
    required this.label,
    required this.items,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 70,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        Flexible(
          fit: FlexFit.loose,
          child: DropdownButtonFormField<String>(
            value: widget.selectedValue,
            hint: Text('Выберите ${widget.label}',
            style: AppTheme.lightTheme.textTheme.labelMedium),
            items: widget.items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                style: AppTheme.lightTheme.textTheme.labelMedium,),
              );
            }).toList(),
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
      ],
      )
    );
  }
}
