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
    GlobalKey<FormState> newPasswordFormKey = GlobalKey<FormState>();

    if (EmailController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email first",
        backgroundColor: const Color(0xff63131C),
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                icon: Image.asset(
                  "assets/Logo.png",
                  height: 70,
                  width: 50,
                ),
                title: const Text("Forgot Password"),
                content: Column(
                  children: [
                    const Text(
                      "Provide your Registered Contact Nummber To Reset Your Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Enter Your Contact Number:",
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
                        hintText: "Start with +92",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xff63131C)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Contact Number";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        securityAnswer = value;
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xff63131C),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      isSecurityAnswerCorrect =
                          await MongoDatabase.validateSecurityAnswer(
                        EmailController.text,
                        securityAnswer,
                      );

                      setState(() {
                        isSecurityAnswerCorrect = isSecurityAnswerCorrect;
                      });

                      if (isSecurityAnswerCorrect) {
                        Navigator.of(context).pop();

                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Reset Password"),
                              content: Form(
                                key: newPasswordFormKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
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
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Color(0xff63131C)),
                                        ),
                                        hintText: "New Password",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your new password";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        newPassword = value;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: retypePasswordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Color(0xff63131C)),
                                        ),
                                        hintText: "Retype Your New Password",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please retype your new password";
                                        }
                                        if (value !=
                                            newPasswordController.text) {
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
                                  child: const Text(
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
                                          backgroundColor:
                                              const Color(0xff63131C),
                                          textColor: Colors.white,
                                          gravity: ToastGravity.BOTTOM,
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                      } else {
                                        await MongoDatabase.changePassword(
                                            EmailController.text, newPassword);
                                        Fluttertoast.showToast(
                                          msg: "Password reset successful",
                                          backgroundColor:
                                              const Color(0xff63131C),
                                          textColor: Colors.white,
                                          gravity: ToastGravity.BOTTOM,
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      }
                                    }
                                  },
                                  child: const Text("Reset Password"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Invalid security answer",
                          backgroundColor: const Color(0xff63131C),
                          textColor: Colors.white,
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_LONG,
                        );
                      }
                    },
                    child: const Text("Next"),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
