import 'package:flutter/material.dart';

class DropdownSelector extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownSelector({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          /*decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),*/
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 5)
      ],
    );
  }
}
