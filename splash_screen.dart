import 'package:flutter/material.dart';
import 'package:ftmithaimart/login_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';


class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // child: Scaffold(
        body: SafeArea(
          child: AnimatedSplashScreen(
            splashIconSize: MediaQuery.of(context).size.height,
            splash: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      Image.asset('assets/Logo.png',width: 150, height: 150,),

                  //Padding(padding: EdgeInsets.all(5)),
                  const Text(
                    "F.T MITHAI MART",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color(0xffA4202E),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xffB59703),
                    ),
                  ),
                  // Padding(padding: EdgeInsets.all(5)),
                  const Text(
                    "Flavourful Traditions In Every Click",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xffA4202E),
                    ),
                  ),
              ]
            ),
            nextScreen: login(),
            splashTransition: SplashTransition.fadeTransition,
            duration: 3000,
            backgroundColor: Color(0xffFFF8E6),
            // Background color of the splash screen
          ),
        ),
    );
  }
}

