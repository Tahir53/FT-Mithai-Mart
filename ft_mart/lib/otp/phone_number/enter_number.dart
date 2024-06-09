import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftmithaimart/otp/otp_screen.dart';
import 'package:http/http.dart' as http;

class EnterNumber extends StatefulWidget {
  final Function() function;

  const EnterNumber({Key? key, required this.function}) : super(key: key);

  @override
  _EnterNumberState createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  final phoneController = TextEditingController();
  bool isSendingOTP = false;

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
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                const Text(
                  'We Need To Verify Your Phone Number To Place The Order.',
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
                      boxShadow: const [
                        BoxShadow(
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
                        child: Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  prefixText: '92',
                                  prefixStyle: const TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                  labelText: 'Contact Number',
                                  labelStyle:
                                      const TextStyle(color: Color(0xff63131C)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Color(0xff63131C)),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Color(0xff63131C),
                                  ),
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
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff63131C),
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

                              setState(() {
                                isSendingOTP = true;
                              });

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
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => OtpScreen(
                                                verificationId:
                                                    randomNumber.toString(),
                                                function: () {
                                                  widget.function();
                                                },
                                                phoneNo: phoneController.text,
                                              )));
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Failed to send OTP",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                }
                              } catch (e) {}

                              setState(() {
                                isSendingOTP = false;
                              });
                            },
                            icon: isSendingOTP
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                  ),
                            label: const Text(
                              "Verify Phone Number",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      widget.function();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => widget.function()));
                    },
                    child: const Text("Skip"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
