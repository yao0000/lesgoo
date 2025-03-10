import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';

class ButtonText extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ButtonText({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? (){},
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.orange,
          fontWeight: FontWeight.bold,
        ),
      )
    );
  }
}
