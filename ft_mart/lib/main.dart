import 'package:flutter/material.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';


import 'screens/homepage/home_page.dart';
import 'screens/authentication/login_page.dart';
import '../splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();

  runApp(const MainApp());
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
      home: const splashscreen(),
      routes: {
        'splash_screen': (context)=> const splashscreen(),
        'login_page':(context)=>const  login(),
        'home_page': (context)=>homepage(name: "User",),
      },
    );
  }
}
