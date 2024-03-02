import 'package:flutter/material.dart';

class AppSnackbar {
  final BuildContext context;

  final String msg;

  AppSnackbar({
    required this.context,
    required this.msg,
  });

  void showSnackbar(BuildContext context) {
    var snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}