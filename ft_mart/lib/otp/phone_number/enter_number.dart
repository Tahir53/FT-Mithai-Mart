import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftmithaimart/otp/otp_screen.dart';
import 'package:http/http.dart' as http;

class EnterNumber extends StatefulWidget {
  final Function() function;

  const EnterNumber({
    Key? key,
    required this.function
  }) : super(key: key);
  @override
  _EnterNumberState createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //build method for UI Representation
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Image.asset(
                  'assets/Logo.png',
                  width: screenWidth * 0.5,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                const Text(
                  'Verification',
                  style: TextStyle(fontSize: 28, color: Colors.black),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                const Text(
                  'Enter your mobile number to receive a verification code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth > 600 ? screenWidth * 0.2 : 16),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff63131C),
                          ),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  prefixText: '92',
                                  hintText: 'Contact Number',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 13.5),
                                ),
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff63131C),
                        ),
                        onPressed: () async {
                          if (phoneController.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Please enter your phone number",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                            return;
                          }

                          Random random = Random();
                          int randomNumber = random.nextInt(90000) + 100000;

                          final apiUrl = Uri.parse(
                              'https://muhammadqsolutions.pythonanywhere.com/send-sms?message=$randomNumber&phone=92${phoneController.text}'); // API endpoint

                          try {
                            var response = await http.get(
                              apiUrl,
                              headers: {
                                'Content-Type': 'application/json',
                                "Access-Control-Allow-Origin": "*"
                              },
                            );

                            if (response.statusCode == 200) {
                              print(
                                  'Message SID: ${json.decode(response.body)['message_sid']}');
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => OtpScreen(
                                            verificationId:
                                                randomNumber.toString(), function: () { widget.function();}, phoneNo: phoneController.text,
                                          )));
                            } else {
                              print(
                                  'Failed to send message. Error: ${response.statusCode}');
                              Fluttertoast.showToast(
                                msg: "Failed to send OTP",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          } catch (e) {
                            // Print error message if an exception occurs
                            print('Exception: $e');
                          }
                        },
                        icon: Icon(
                          Icons.verified,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Verify Phone Number",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
