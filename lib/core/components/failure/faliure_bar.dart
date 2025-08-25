import 'package:flutter/material.dart';

void faliureBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red.shade600,
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
