import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/components/admindrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class admin extends StatefulWidget {
  final String name;
  final String? email;
  final String? contact;

  admin({required this.name, this.email, this.contact});

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  String? text;

  Future<String?> getData() async {
    var data = await SharedPreferences.getInstance();
    return data.getString("user");
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset(
            "assets/Logo.png",
            width: 50,
            height: 50,
            // alignment: Alignment.center,
          ),
        ),
        backgroundColor: const Color(0xff801924),
      ),
      drawer: AdminDrawer(
          name: widget.name, email: widget.email, contact: widget.contact),
      body: const SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 10),
            child: Text(
              "Welcome, Admin!",
              style: TextStyle(
                color: Color(0xFF63131C),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
