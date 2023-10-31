import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/login_page.dart';

class signup extends StatefulWidget{
  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
          children: [
            AppBar(
              backgroundColor: Color(0xff801924),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              flexibleSpace: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 100)),
                    Expanded(
                      flex: 3,
                      child: Image.asset(
                        "assets/Logo.png",
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Column(
              children: [
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Sign Up Here",
                  style: TextStyle(
                    color: Color(0xff63131C),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                 // top: MediaQuery.of(context).size.height*1,
                left: 25,
                right: 25,
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Row(
                    children: [
                      Text("Please Enter Your First Name",style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "First Name",
                      hintText: "Enter Your First Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 15)),
                  Row(
                    children: [
                      Text("Please Enter Your Last Name",style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                    ],
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      hintText: "Enter Your Last Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 15)),
                  Row(
                    children: [
                      Text("Please Enter Your Email",style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                    ],
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "someone@example.com",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 15)),
                  Row(
                    children: [
                      Text("Please Enter Password",style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                    ],
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),


                  Padding(padding: EdgeInsets.only(top: 15)),
                  Row(
                    children: [
                      Text("Please Enter Your Contact Number",style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                    ],
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Contact Number",
                      hintText: "Start with +92",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => login()));
                    },
                    icon: const Icon(
                      Icons.verified_outlined,
                      size: 24.0,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff801924),
                        fixedSize: Size(360, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    label: const Text(
                      "Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                ],
              ),
            )
          ]),
        ),
      )
    );
  }
}