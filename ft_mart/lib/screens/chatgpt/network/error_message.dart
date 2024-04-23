import 'package:flutter/material.dart';

void errorMessage(BuildContext context, text) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Something went wrong. please try again later"),
      backgroundColor: Colors.lightBlue,
    ),
  );
  // Get.snackbar("Something went wrong. please try again later", "$text");
  Navigator.pop(context);
}
