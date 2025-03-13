import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(title, style: TextStyle(color: AppColors.navyBlue)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
