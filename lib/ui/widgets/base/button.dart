import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final Color textColor;

  const Button({
    super.key,
    required this.text,
    this.onPressed,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onPressed ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
          ),
          child: Text(text, style: TextStyle(color: textColor)),
        ),
      ],
    );
  }
}
