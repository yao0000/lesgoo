import 'package:flutter/material.dart';

import 'base/button.dart';

class ButtonAction extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;

  const ButtonAction({super.key, required this.label, this.onPressed, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Button(
      text: label,
      onPressed: onPressed,
      buttonColor: Colors.orange,
      textColor: Colors.black,
      borderColor: isSelected ? Colors.black : Colors.transparent 
    );
  }
}
