import 'package:flutter/material.dart';

class InputPassword extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextEditingController? otherPasswordController;

  const InputPassword({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.otherPasswordController,
  });

  @override
  State<StatefulWidget> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(widget.label, style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscurePassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "this field is required";
            }
            if (value.length < 6) {
              return "Password must be at least 6 characters";
            }
            if (widget.otherPasswordController != null) {
              if (widget.otherPasswordController?.text !=
                  widget.controller.text) {
                return "Passwords do not match";
              }
            }

            return null;
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: IconButton(
              onPressed: _togglePasswordVisibility,
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
