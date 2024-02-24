import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftmithaimart/dbHelper/mongodb.dart';
import 'package:ftmithaimart/model/customer_model.dart';
import "package:mongo_dart/mongo_dart.dart" as M;
import 'login_page.dart';

class signup extends StatefulWidget {
  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  void initState() {
    super.initState();
    emailController.addListener(validateEmail);
    contactController.addListener(validateContact);
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  bool isloading = false;
  String errorMessage = "";
  final signupkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: signupkey,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(children: [
          AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
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
              ),
            ),
            backgroundColor: const Color(0xff801924),
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
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
            ),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 25)),
                const Row(
                  children: [
                    Text(
                      "Enter Your First Name",
                      style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: "First Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xff63131C)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your First Name";
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                const Row(
                  children: [
                    Text(
                      "Enter Your Last Name",
                      style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    hintText: "Last Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xff63131C)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your Last Name";
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                const Row(
                  children: [
                    Text(
                      "Enter Your Email Address",
                      style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "someone@example.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xff63131C)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email address";
                    }
                    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                        .hasMatch(value)) {
                      return "Email not in correct format";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                        .hasMatch(value)) {
                      setState(() {
                        errorMessage = "Email not in correct format";
                      });
                    } else {
                      setState(() {
                        errorMessage = "";
                      });
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                const Row(
                  children: [
                    Text(
                      "Enter Password",
                      style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: passwordController,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xff63131C)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please type your Password";
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                const Row(
                  children: [
                    Text(
                      "Enter Your Contact Number",
                      style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: contactController,
                  decoration: InputDecoration(
                    hintText: "Start with +92",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xff63131C)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please type Contact Number Starting with +92";
                    }
                    if (!RegExp(r'^\+92[0-9]{10}$').hasMatch(value)) {
                      return "Contact Number incomplete or not in correct format";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    if (!RegExp(r'^\+92[0-9]{10}$').hasMatch(value)) {
                      setState(() {
                        errorMessage =
                            "Contact Number incomplete or not in correct format";
                      });
                    } else {
                      setState(() {
                        errorMessage = "";
                      });
                    }
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                const Row(
                  children: [
                    Text(
                      "What is your Birthplace?",
                      style: TextStyle(
                        color: Color(0xff63131C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        isloading = true;
                      });
                      if (signupkey.currentState!.validate()) {
                        var id = M.ObjectId();
                        final data = CustomerModel(
                          name:
                              "${firstNameController.text} ${lastNameController.text}",
                          email: emailController.text,
                          password: passwordController.text,
                          contact: contactController.text,
                        );

                        var result = await MongoDatabase.insert(data);
                        showSuccessMessage();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => login()));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please fill the required fields",
                            backgroundColor: Color(0xff63131C),
                            textColor: Colors.white,
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_LONG);
                      }
                      setState(() {
                        isloading = false;
                      });
                    },
                    icon: const Icon(
                      Icons.verified_outlined,
                      size: 24.0,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff801924),
                        fixedSize: const Size(360, 55),
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
                    )),
              ],
            ),
          )
        ]),
      )),
    );
  }

  void validateEmail() {
    final val = emailController.text;
    if (val.isEmpty) {
      setState(() {
        errorMessage = "Email can not be empty";
      });
    } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(val)) {
      setState(() {
        errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        errorMessage = "";
      });
    }
  }

  void validateContact() {
    final val = contactController.text;
    if (val.isEmpty) {
      setState(() {
        errorMessage = "Contact Number can not be empty";
      });
    } else if (!RegExp(r'^\+92[0-9]{10}$').hasMatch(val)) {
      setState(() {
        errorMessage = "Invalid Contact Number";
      });
    } else {
      setState(() {
        errorMessage = "";
      });
    }
  }

  void showSuccessMessage() {
    Fluttertoast.showToast(
        msg: "Registration Successful",
        backgroundColor: Color(0xff63131C),
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }
}
