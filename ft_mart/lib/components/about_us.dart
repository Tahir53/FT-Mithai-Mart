import 'package:flutter/material.dart';
import 'drawer.dart';

class aboutus extends StatefulWidget {
  final String name;

  const aboutus({super.key, required this.name});

  @override
  State<aboutus> createState() => _aboutusState();
}

class _aboutusState extends State<aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
        ),
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.all(0.0),
          child: Text("FT MITHAI MART",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
        backgroundColor: const Color(0xff801924),
      ),
      drawer: CustomDrawer(
        name: widget.name,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Logo.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to FT Mithai Mart',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'At FT Mithai Mart, we take pride in delivering the finest and freshest mithai (sweets) to your doorstep. Our commitment to quality and customer satisfaction is our top priority.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Our Story',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Since 1920, FT Sweets has been a family-owned business dedicated to preserving the rich traditions of Bombay Line Mithai. Our Mithai is made with love and using traditional recipes that have been passed down for generations.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Have questions or feedback? We would love to hear from you. You can reach us at:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Email: ftsweets@gmail.com',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Text(
                'Phone: +92 (021) 32790508',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
