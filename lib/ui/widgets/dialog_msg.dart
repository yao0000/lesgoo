import 'package:flutter/material.dart';

void showMessageDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

Future<bool?> showConfirmationDialog(
  BuildContext context,
  String title,
  String content,
) {
  return showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: Text("Confirm"),
            ),
          ],
        ),
  );
}
