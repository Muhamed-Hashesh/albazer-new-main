import 'package:flutter/material.dart';

class AppMessages {
  static bool _isLoading = false;
  static Future<dynamic> showLoading(BuildContext context) {
    if (_isLoading) return Future.value();
    _isLoading = true;
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    if (_isLoading) {
      _isLoading = false;
      Navigator.pop(context);
    }
  }

  static void showError(BuildContext context, String error,
      [SnackBarAction? action]) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
            // border: const Border(
            //   top: BorderSide(
            //     color: Colors.red,
            //     width: 4,
            //   ),
            // ),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            error,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        action: action,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message,
      [SnackBarAction? action]) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            // border: Border(
            //   top: BorderSide(
            //     color: Colors.green,
            //     width: 4,
            //   ),
            // ),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        action: action,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}
