import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../dbHelper/mongodb.dart';

class ForgotPassword {
  static Future<void> showForgotPasswordDialog(
      BuildContext context, TextEditingController EmailController) async {
    String securityAnswer = '';
    String newPassword = '';
    TextEditingController answerController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController retypePasswordController = TextEditingController();
    bool isSecurityAnswerCorrect = false;
    bool hidePassword = true;
    GlobalKey<FormState> newPasswordFormKey = GlobalKey<FormState>();

    if (EmailController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email first",
        backgroundColor: Color(0xff63131C),
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              icon: Image.asset(
                "assets/Logo.png",
                height: 70,
                width: 50,
              ),
              title: Text("Forgot Password"),
              content: Column(
                children: [
                  Text(
                    "Answer the security question to reset your password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Security Question:", // Adjust this text accordingly
                      style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: answerController,
                    decoration: InputDecoration(
                      hintText: "Birth Place",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xff63131C)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Birthplace";
                      }
                    },
                    onChanged: (value) {
                      securityAnswer = value;
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xff63131C),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("Email: ${EmailController.text}");
                    print("Security Answer: $securityAnswer");

                    isSecurityAnswerCorrect =
                        await MongoDatabase.validateSecurityAnswer(
                      EmailController.text,
                      securityAnswer,
                    );

                    setState(() {
                      isSecurityAnswerCorrect = isSecurityAnswerCorrect;
                    });

                    if (isSecurityAnswerCorrect) {
                      Navigator.of(context).pop(); // Close the current dialog

                      // Show a new dialog for entering the new password
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Reset Password"),
                            content: Form(
                              key: newPasswordFormKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Enter Your New Password:",
                                      style: TextStyle(
                                        color: Color(0xff63131C),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: newPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Color(0xff63131C)),
                                      ),
                                      hintText: "New Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your new password";
                                      }
                                    },
                                    onChanged: (value) {
                                      newPassword = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: retypePasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Color(0xff63131C)),
                                      ),
                                      hintText: "Retype Your New Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please retype your new password";
                                      }
                                      if (value != newPasswordController.text) {
                                        return "Passwords do not match";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Color(0xff63131C),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (newPasswordFormKey.currentState!
                                      .validate()) {
                                    if (newPasswordController.text !=
                                        retypePasswordController.text) {
                                      Fluttertoast.showToast(
                                        msg: "Passwords do not match",
                                        backgroundColor: Color(0xff63131C),
                                        textColor: Colors.white,
                                        gravity: ToastGravity.BOTTOM,
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                    } else {
                                      await MongoDatabase.changePassword(
                                          EmailController.text, newPassword);
                                      print("Password changed successfully");
                                      Fluttertoast.showToast(
                                        msg: "Password reset successful",
                                        backgroundColor: Color(0xff63131C),
                                        textColor: Colors.white,
                                        gravity: ToastGravity.BOTTOM,
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    }
                                  }
                                },
                                child: Text("Reset Password"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // If the security answer is incorrect, show an error message
                      // ...
                      Fluttertoast.showToast(
                        msg: "Invalid security answer",
                        backgroundColor: Color(0xff63131C),
                        textColor: Colors.white,
                        gravity: ToastGravity.BOTTOM,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                  child: Text("Next"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
