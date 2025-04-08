import 'package:flutter/material.dart';

Widget noDataScreen(String label) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/img/empty.png"),
        const SizedBox(height: 16),
        Text(label),
      ],
    ),
  );
}
