import 'package:flutter/material.dart';

class TechCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TechCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          
          
        ),
        Expanded(
          child: Text(
            label,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
