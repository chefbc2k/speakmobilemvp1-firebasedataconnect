import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';

class ErrorHandler {
  static void showError({
    required BuildContext context,
    required Object error,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final errorMessage = message ?? error.toString();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
        duration: duration,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }
}
