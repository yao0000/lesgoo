import 'package:flutter/material.dart';

Widget buildIconInfo(
  IconData icon,
  String value, 
  { 
    Color? iconColor = Colors.grey,
    bool isOverflow = false,
    double? fontSize = 16.0
    }
  ) {
  return Row(
    children: [
      Icon(icon, color: iconColor),
      SizedBox(width: 5),
      if (isOverflow)
        Text(
          value,
          style: TextStyle(color: Colors.black54),
          overflow: TextOverflow.ellipsis,
        ),
      if (!isOverflow)
        Text(value, style: TextStyle(fontSize: fontSize, color: Colors.black54))
    ],
  );
}
