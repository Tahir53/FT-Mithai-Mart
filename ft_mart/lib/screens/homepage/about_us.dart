import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/drawer.dart';

class aboutus extends StatefulWidget{
  final String name;
  aboutus({required this.name});
  @override
  State<aboutus> createState() => _aboutusState();
}

class _aboutusState extends State<aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text("FT MITHAI MART",style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,

          )
            // alignment: Alignment.center,
          ),
        ),

        backgroundColor: const Color(0xff801924),
      ),
      drawer: CustomDrawer(name: widget.name,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Logo.png', // Your business logo
                height: 150,
                width: 150,
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to FT Mithai Mart',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'At FT Mithai Mart, we take pride in delivering the finest and freshest mithai (sweets) to your doorstep. Our commitment to quality and customer satisfaction is our top priority.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Our Story',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Since 1920, FT Sweets has been a family-owned business dedicated to preserving the rich traditions of Bombay Line Mithai. Our Mithai is made with love and using traditional recipes that have been passed down for generations.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Have questions or feedback? We would love to hear from you. You can reach us at:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Email: ftsweets@gmail.com',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Phone: +1 (123) 456-7890',
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