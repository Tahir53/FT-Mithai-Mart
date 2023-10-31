import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftmithaimart/admin_page.dart';
import 'package:ftmithaimart/home_page.dart';
import 'package:ftmithaimart/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/material/icons.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _loginkey = GlobalKey<FormState>();
  String errorMessage = "";
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  bool hidePassword = true;

  Widget build(BuildContext context) {
    return Form(
      key: _loginkey,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    const Padding(
                        padding:
                            EdgeInsets.only(left: 500, top: 60, right: 500)),
                    Image.asset(
                      'assets/Logo.png',
                      width: 60,
                      height: 60,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    const Text(
                      "Login or Signup",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xffA4202E),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.08,
                      left: 25,
                      right: 25),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: EmailController,
                        decoration: InputDecoration(
                          labelText: "Username/Email",
                          hintText: " someone@example.com",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.person),
                            onPressed: () {},
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please type username or Email!";
                          }
                          if (!RegExp(r"\b[\w\.-]+@szabist.pk")
                              .hasMatch(value)) {
                            return "Email not in correct format";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (!RegExp(r"\b[\w\.-]+@szabist.pk")
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
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: PasswordController,
                        obscureText: hidePassword,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          labelText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: Color(0xff63131C),
                          ),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.lock),
                            onPressed: () {},
                          ),
                          hintText: "Enter Your Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please type Password!";
                          }

                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            errorMessage = "";
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (_loginkey.currentState!.validate()) {
                                final SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                await pref.setString("user", "Tahir");
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return admin();
                                  },
                                ));
                              }
                            },
                            icon: const Icon(
                              Icons.login,
                              size: 24.0,
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff801924),
                                fixedSize: Size(360, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            label: const Text(
                              "Log in",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color(0xff801924),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(15)),
                          const Text(
                            "OR",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          ElevatedButton.icon(
                              // <-- ElevatedButton
                              onPressed: () {},
                              icon: const Icon(
                                Icons.email,
                                size: 24.0,
                                color: Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xffD9D9D9),
                                  fixedSize: Size(360, 55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              label: const Text(
                                'Continue with google',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                                final SharedPreferences pref =
                                await SharedPreferences.getInstance();
                                await pref.setString("user", "User");
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return homepage();
                                      },
                                    ));
                            },
                            icon: const Icon(
                              Icons.people,
                              size: 24.0,
                              color: Colors.black,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xffffC937),
                                fixedSize: Size(360, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            label: const Text(
                              "Continue as a guest",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
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
                                      builder: (context) => signup()));
                            },
                            icon: const Icon(
                              Icons.app_registration,
                              size: 24.0,
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff801924),
                                fixedSize: Size(360, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            label: const Text(
                              "Sign Up",
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
                      const Column(
                        children: [
                          Padding(padding: EdgeInsets.all(20)),
                          Text(
                            "By continuing, you agree to F.T Mithai Mart's Terms & Conditions & Privacy Policy",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void validateEmail() {
    final val = EmailController.text;
    if (val.isEmpty) {
      setState(() {
        errorMessage = "Email can not be empty";
      });
    } else if (!RegExp(r"^[\w-\.]+@szabist.pk").hasMatch(val)) {
      setState(() {
        errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        errorMessage = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    EmailController.addListener(validateEmail);
    PasswordController.addListener(validatePassword);
  }

  void validatePassword() {
    final val = PasswordController.text;
    if (val.isEmpty) {
      setState(() {
        errorMessage = "Passsword can not be empty";
      });
      // } else if (!RegExp(r"^[\w-\.]+@szabist.pk").hasMatch(val)) {
      //   setState(() {
      //     errorMessage = "Invalid Email Address";
      //   });
    } else {
      setState(() {
        errorMessage = "";
      });
    }
  }
}
