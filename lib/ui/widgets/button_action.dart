import 'package:flutter/material.dart';

import 'base/button.dart';

class ButtonAction extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ButtonAction({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Button(
      text: label,
      onPressed: onPressed,
      buttonColor: Colors.orange,
      textColor: Colors.black,
    );
  }
}
