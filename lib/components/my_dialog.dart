import 'package:flutter/material.dart';

void showMyDialog(
    {required BuildContext context,
    required String title,
    required String description}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
