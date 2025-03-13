import 'package:flutter/material.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/ui/widgets/base/custom_app_bar.dart';

class TravellerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TravellerAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(title: title, backgroundColor: AppColors.bgColor,);
  }

    @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
