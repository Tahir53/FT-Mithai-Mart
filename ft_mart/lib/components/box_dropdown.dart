import 'package:flutter/material.dart';

class BoxDropdown extends StatelessWidget {
  final String title;
  final String selectedValue;
  final List<DropdownMenuItem<String>> items;
  final Function(String?) onChanged;

  const BoxDropdown({
    Key? key,
    required this.title,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            flex: 3,
            child: DropdownButton<String>(
              value: selectedValue,
              onChanged: onChanged,
              items: items,
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }
}
