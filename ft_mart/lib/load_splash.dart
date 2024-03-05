// import 'package:flutter/material.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:ftmithaimart/screens/homepage/home_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'screens/authentication/login_page.dart';

// class loadsplashscreen extends StatefulWidget {
//   const loadsplashscreen({super.key});

//   @override
//   State<loadsplashscreen> createState() => _loadsplashscreenState();
// }

// class _loadsplashscreenState extends State<loadsplashscreen> {
//   @override
//   void initState() {
//     checkWhereToNavigate();
//     super.initState();
//   }

//   checkWhereToNavigate() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? isLoggedIn = prefs.getBool('isLoggedIn');
//     print("in where to navigate $isLoggedIn");
//     if (isLoggedIn != null) {
//       if (isLoggedIn == true){
//         Navigator.push(context, MaterialPageRoute(builder: (_) => homepage(name: "User")));
//       }
//       // else if (isLoggedIn == false){
//       //   Navigator.push(context, MaterialPageRoute(builder: (_) => login()));
//       // }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // child: Scaffold(
//       body: SafeArea(
//         child: AnimatedSplashScreen(
//           splashIconSize: MediaQuery.of(context).size.height,
//           splash: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/Logo.png',
//                   width: 150,
//                   height: 150,
//                 ),
//                 const Text(
//                   "F.T MITHAI MART",
//                   style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 24,
//                       color: Color(0xffA4202E),
//                       decoration: TextDecoration.underline,
//                       decorationColor: Color(0xffB59703),
//                       fontFamily: 'Montserrat'),
//                 ),
//                 const Text(
//                   "Flavourful Traditions In Every Click",
//                   style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 12,
//                       color: Color(0xffA4202E),
//                       fontFamily: 'Montserrat'),
//                 ),
//                 const Text(
//                   "Flavourful Traditions In Every Click sdasdasd",
//                   style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 12,
//                       color: Color(0xffA4202E),
//                       fontFamily: 'Montserrat'),
//                 ),
//               ]),
//           nextScreen: login(),
//           splashTransition: SplashTransition.fadeTransition,
//           duration: 2000,
//           backgroundColor: Color(0xffFFF8E6),
//         ),
//       ),
//     );
//   }
// }
