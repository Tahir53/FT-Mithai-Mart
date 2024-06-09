import 'package:flutter/material.dart';
import 'package:ftmithaimart/screens/authentication/login_page.dart';
import 'package:ftmithaimart/screens/homepage/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    flowLogic();
  }

  flowLogic() async {
    await Future.delayed(const Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    String name = prefs.getString('name') ?? "User";
    String contact = prefs.getString('contact') ?? "";
    String email = prefs.getString('email') ?? "";

    if (isLoggedIn != null) {
      if (isLoggedIn == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    homepage(name: name, contact: contact, email: email)));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const login()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          color: Color(0xffFFF8E6),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Logo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              // Adding some space between the image and text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/splash.png',
                    width: 24, // Adjust the width as needed
                    height: 24, // Adjust the height as needed
                  ),
                  const SizedBox(width: 5),
                  // Adding some space between the icon and text
                  const Text(
                    'GEAR UP FOR SWEETNESS GALORE',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xffA4202E),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
