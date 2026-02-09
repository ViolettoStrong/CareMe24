import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, {required String text}) async {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ));
}
