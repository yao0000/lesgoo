import 'package:flutter/material.dart';

import 'base/button.dart';

class ButtonAction extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;
  final Color btnColor;

  const ButtonAction({super.key, required this.label, this.onPressed, this.isSelected = false, this.btnColor = Colors.orange});

  @override
  Widget build(BuildContext context) {
    return Button(
      text: label,
      onPressed: onPressed,
      buttonColor: btnColor,
      textColor: Colors.black,
      borderColor: isSelected ? Colors.black : Colors.transparent 
    );
  }
}
