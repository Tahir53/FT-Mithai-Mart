import 'package:flutter/material.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:ftmithaimart/screens/homepage/about_us.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/homepage/home_page.dart';
import 'screens/authentication/login_page.dart';
import '../splash_screen.dart';
import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
void main() async {
//await Firebase.initializeApp(
  //options: DefaultFirebaseOptions.currentPlatform,
//);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<void> _initializeApp() async {
    await MongoDatabase.connect().catchError((error) {
      print('Failed to connect to the database: $error');
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

