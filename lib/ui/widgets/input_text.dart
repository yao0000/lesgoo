import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool isRequired;
  final TextInputType keyboardType;
  final bool readOnly;

  const InputText({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          readOnly: readOnly,
          controller: controller,
          validator: (value) {
            if (!isRequired) {
              return null;
            }
            if (value!.trim().isEmpty) {
              return "This field is required";
            }
            if (keyboardType == TextInputType.emailAddress &&
                !RegExp(
                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                ).hasMatch(value)) {
              return "Invalid email";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
