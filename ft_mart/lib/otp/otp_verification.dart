import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/screens/homepage/home_page.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String generatedOTP;

  const OTPVerificationScreen({Key? key, required this.generatedOTP}) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late String enteredOTP;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                ),
                onChanged: (value) {
                  enteredOTP = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  verifyOTP();
                },
                child: Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyOTP() {
    if (enteredOTP == widget.generatedOTP) {
      // OTP verification successful
      // You can navigate to the next screen or perform any other action
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => homepage(name: "user"),
        ),
      );
    } else {
      // OTP verification failed
      // You can display an error message or handle the failure as per your requirement
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('OTP Verification Failed'),
          content: Text('Invalid OTP. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}