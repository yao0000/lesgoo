import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const Button({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onPressed ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navyBlue,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
          ),
          child: Text(text, style: TextStyle(color: AppColors.white)),
        ),
      ],
    );
  }
}
