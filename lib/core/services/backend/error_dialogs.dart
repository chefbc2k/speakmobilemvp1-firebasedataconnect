import 'package:flutter/cupertino.dart';

// Placeholder for ErrorDialogs
class ErrorDialogs {
  static void showProcessingDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
