import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/forgot_password.dart';
import '../../dbHelper/mongodb.dart';
import '../homepage/admin_page.dart';
import '../homepage/home_page.dart';
import 'signup_page.dart';

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
  bool isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> data(String email, String password) async {
    print("data() called in login_page");
    return await MongoDatabase.getData(email, password);
  }

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
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xff63131C)),
                          ),
                          labelText: "Username/Email",
                          labelStyle: TextStyle(
                            color: Color(0xff63131C),
                          ),
                          hintText: " someone@example.com",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.person,
                              color: Color(0xff63131C),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please type username or Email!";
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
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: PasswordController,
                        obscureText: hidePassword,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Color(0xff63131C),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xff63131C)),
                          ),
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
                            icon: Icon(
                              Icons.lock,
                              color: Color(0xff63131C),
                            ),
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
                          ElevatedButton(
                            onPressed: () async {
                              if (_loginkey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                var res = await data(
                                    EmailController.text.toString(),
                                    PasswordController.text.toString());
                                if (res["error"] == null) {
                                  if (res["admin"] == true) {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return admin(
                                            name: res["name"],
                                            email: res["email"],
                                            contact: res["contact"]);
                                      },
                                    ));
                                  } else {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('isLoggedIn', true);
                                    prefs.setString('email', res["email"]);
                                    prefs.setString('name', res["name"]);
                                    prefs.setString('contact', res["contact"]);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return homepage(
                                            name: res["name"],
                                            email: res["email"],
                                            contact: res["contact"]);
                                      },
                                    ));
                                  }
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Invalid username or password",
                                      backgroundColor: Color(0xff63131C),
                                      textColor: Colors.white,
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_LONG);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff801924),
                                fixedSize: Size(360, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            child: !isLoading
                                ? const Text(
                                    "Login",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          TextButton(
                            onPressed: () async {
                              await ForgotPassword.showForgotPasswordDialog(
                                  context, EmailController);
                            },
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
                              onPressed: () {
                                signInWithGoogle();
                              },
                              icon: Image.asset(
                                'assets/google.png',
                                height: 30,
                                width: 30,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffD9D9D9),
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
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  // return HomeScreen();
                                  return homepage(
                                    name: "User",
                                  );
                                },
                              ));
                            },
                            icon: const Icon(
                              Icons.people,
                              size: 24.0,
                              color: Colors.black,
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffffC937),
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
                              color: Colors.white,
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

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      final User? user = authResult.user;
      print("User signed in with google: $user");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => homepage(name: "user")));
      // print("Signed in with google succesfully");
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  void validateEmail() {
    final val = EmailController.text;
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
    } else {
      setState(() {
        errorMessage = "";
      });
    }
  }
}
