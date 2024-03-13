import 'package:flutter/material.dart';
import 'package:otp/otp.dart';

import 'otp_verification.dart'; // Import the package for OTP generation

class PhoneNumberInputScreen extends StatefulWidget {
  @override
  _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  late String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Phone Number'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  generateAndSendOTP(phoneNumber);
                },
                child: Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void generateAndSendOTP(String phoneNumber) {
    // Generate OTP
    String generatedOTP = OTP.generateTOTPCodeString('5253', DateTime.now().millisecondsSinceEpoch);

    // Send OTP to the provided phone number (Implement your logic here)
    // You can use an SMS service provider or any other method to send the OTP

    // After sending OTP, navigate to the OTP verification screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationScreen(generatedOTP: generatedOTP),
      ),
    );
  }
}