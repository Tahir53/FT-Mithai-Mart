import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftmithaimart/screens/homepage/home_page.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class OtpScreen extends StatefulWidget {

  var _contact = '';
  final String verificationId;
  final Function() function;
  OtpScreen({
    Key? key,
    required this.verificationId,
    required this.function,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String phoneNo;
  late String smsOTP;
  String errorMessage = '';
  final _otpPinFieldKey = GlobalKey<OtpPinFieldState>();
  TextEditingController OtpController = TextEditingController();

  @override

  //dispose controllers
  @override
  void dispose() {
    super.dispose();
  }

  //build method for UI
  @override
  Widget build(BuildContext context) {
    //Getting screen height width
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
                Text(
                  'Enter A 6 digit number that was sent to ${widget._contact}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth > 600 ? screenWidth * 0.2 : 2),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: screenWidth * 0.025),
                        child: OtpPinField(
                          key: _otpPinFieldKey,
                          keyboardType: TextInputType.numberWithOptions(decimal: false),
                          textInputAction: TextInputAction.done,
                          maxLength: 6,
                          fieldWidth: 30,
                          onSubmit: (String text) {  },
                          onChange: (String text) {  },
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff63131C),
                        ),
                          onPressed: () async {
                            try {
                              PhoneAuthCredential credential =
                              await PhoneAuthProvider.credential(
                                  verificationId: widget.verificationId,
                                  smsCode: OtpController.text.toString());
                              FirebaseAuth.instance.signInWithCredential(credential);
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage(name: "user")));
                            } catch (ex) {
                              //log(ex.toString())

                            }
                          },
                          icon: Icon(Icons.verified_outlined,color: Colors.white,),
                          label: Text("Verify OTP",style: TextStyle(
                            color: Colors.white,
                          ),))

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


  //Method for handle the errors
  void handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        showAlertDialog(context, 'Invalid Code');
        break;
      default:
        showAlertDialog(context, error.message ?? 'Error');
        break;
    }
  }

  //Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
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


}
