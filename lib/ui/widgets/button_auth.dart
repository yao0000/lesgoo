import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';

import 'base/button.dart';

class ButtonAuth extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ButtonAuth({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Button(
      text: label,
      onPressed: onPressed,
      buttonColor: AppColors.navyBlue,
      textColor: Colors.white,
    );
  }
}
