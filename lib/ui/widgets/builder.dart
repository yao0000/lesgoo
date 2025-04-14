import 'package:flutter/material.dart';
import 'package:travel/ui/widgets/card_holder.dart';

Widget buildHorizontalList<T>(double screenWidth, List<T> list) {
  return SizedBox(
    height: 180,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder:
          (context, index) =>
              CardHolder(screenWidth: screenWidth * 0.6, item: list[index]),
    ),
  );
}
