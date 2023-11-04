import 'package:flutter/material.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';


import 'screens/homepage/home_page.dart';
import 'screens/authentication/login_page.dart';
import '../splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
  // await MongoDatabase.connect().catchError((error) {
  //   print('Failed to connect to the database: $error');
  //   // Handle the error here, e.g., log it or notify the user.
  // }).whenComplete(() {
  //   runApp(const MainApp());
  // });

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  Future<void> _initializeApp() async {
    await MongoDatabase.connect().catchError((error) {
      print('Failed to connect to the database: $error');
      // Handle the error here, e.g., log it or notify the user.
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      title: "F.T MithaiMart",
      home: FutureBuilder(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const login();
          } else {
            return const splashscreen();
          }
        },
      ),
      routes: {
        'splash_screen': (context)=> const splashscreen(),
        'login_page':(context)=>const  login(),
        'home_page': (context)=>homepage(name: "User",),
      },
    );
  }
}
