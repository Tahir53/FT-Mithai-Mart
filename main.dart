import 'package:flutter/material.dart';
import 'package:ftmithaimart/home_page.dart';
import 'package:ftmithaimart/login_page.dart';
import 'package:ftmithaimart/splash_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: splashscreen(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      title: "F.T MithaiMart",
      //debugShowCheckedModeBanner: false,
      home: splashscreen(),
      //initialRoute: 'splash_screen',
      routes: {
        'splash_screen': (context)=>splashscreen(),
        'login_page':(context)=>login(),
        'home_page': (context)=>homepage(),
      },
    );
  }
}
