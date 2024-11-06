import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';

class ErrorHandler {
  static void showError({
    required BuildContext context,
    required Object error,
    String? message,
  }) {
    final errorMessage = message ?? error.toString();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
