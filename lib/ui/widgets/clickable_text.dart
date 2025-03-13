import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';

class ClickableText extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ClickableText({super.key, required this.label, this.onPressed});

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
