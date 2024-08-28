import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:health_insight/ui_helper/util.dart';

import 'forget_password_screen.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  var userNameController = TextEditingController();
  var passWordController = TextEditingController();

  bool showSpinner = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  String result = "";

  bool canPopNow = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPopNow,
      onPopInvoked: (bool value) {
        setState(() {
          canPopNow = !value;
        });

        if (canPopNow) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Click once more to go back"),
              duration: Duration(milliseconds: 1500),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(),
        ),
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hey there',
                  style: bodyTextStyle(),
                ),
                Text('Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: userNameController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color(0xffADA4A5),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Image.asset('assets/images/Message.png'),
                    label: const Text(
                      'Email',
                      style: TextStyle(color: Color(0xffADA4A5)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xffF7F8F8),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passWordController,
                  obscureText: true,
                  obscuringCharacter: "*",
                  style: const TextStyle(
                    color: Color(0xffADA4A5),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Image.asset('assets/images/Lock.png'),
                    label: const Text(
                      'Password',
                      style: TextStyle(color: Color(0xffADA4A5)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xffF7F8F8),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(
                          color: Color(0xffADA4A5),
                          fontSize: 12,
                          fontFamily: 'PoppinsMedium',
                          decoration: TextDecoration.underline),
                      children: [
                        TextSpan(
                          text: "Forget Password?",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ForgetPasswordScreen();
                                },
                              ));
                            },
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xff9DCEFF),
                        Color(0xff92A3FD),
                      ]),
                      borderRadius: BorderRadius.circular(100)),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.transparent),
                      shadowColor:
                          WidgetStateProperty.all<Color>(Colors.transparent),
                    ),
                    // onPressed: () async {
                    //   setState(() {
                    //     showSpinner = true;
                    //   });
                    //   try {
                    //     UserCredential userCredential =
                    //         await auth.signInWithEmailAndPassword(
                    //             email: userNameController.text,
                    //             password: passWordController.text);
                    //     user = userCredential.user;
                    //     if (user != null) {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) {
                    //             return HomeScreen();
                    //           },
                    //         ),
                    //       );
                    //     }
                    //     setState(() {
                    //       showSpinner = false;
                    //     });
                    //   } on FirebaseAuthException catch (e) {
                    //     if (e.code == 'user-not-found') {
                    //       result = 'No user found for that email.';
                    //     } else if (e.code == 'wrong-password') {
                    //       result = 'Wrong password provided.';
                    //     }
                    //   } catch (e) {
                    //     print(e);
                    //   }
                    // },
                    // onPressed: () async {
                    //   setState(() {
                    //     showSpinner = true;
                    //     result = ""; // Clear previous result
                    //   });
                    //
                    //   try {
                    //     UserCredential userCredential =
                    //         await auth.signInWithEmailAndPassword(
                    //       email: userNameController.text,
                    //       password: passWordController.text,
                    //     );
                    //     user = userCredential.user;
                    //
                    //     if (user != null) {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) {
                    //             return HomeScreen();
                    //           },
                    //         ),
                    //       );
                    //     }
                    //   } on FirebaseAuthException catch (e) {
                    //     if (e.code == 'user-not-found') {
                    //       setState(() {
                    //         result = 'No user found for that email.';
                    //       });
                    //     } else if (e.code == 'wrong-password') {
                    //       setState(() {
                    //         result = 'Wrong password provided.';
                    //       });
                    //     } else {
                    //       setState(() {
                    //         result =
                    //             'An unexpected error occurred. Please try again.';
                    //       });
                    //     }
                    //   } catch (e) {
                    //     setState(() {
                    //       result = 'An error occurred. Please try again later.';
                    //     });
                    //     print(e);
                    //   } finally {
                    //     setState(() {
                    //       showSpinner = false;
                    //     });
                    //   }
                    // },
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                        result = ""; // Clear previous result
                      });

                      try {
                        UserCredential userCredential =
                            await auth.signInWithEmailAndPassword(
                          email: userNameController.text,
                          password: passWordController.text,
                        );
                        user = userCredential.user;

                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomeScreen();
                              },
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          if (e.code == 'user-not-found') {
                            result = 'No user found for that email.';
                          } else if (e.code == 'wrong-password') {
                            result = 'Wrong password provided.';
                          } else {
                            result =
                                'An unexpected error occurred. Please try again.';
                          }
                        });
                      } catch (e) {
                        setState(() {
                          result = 'An error occurred. Please try again later.';
                        });
                        print("Error: $e");
                      } finally {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Login.png', // Replace with your asset path
                          height: 24.0,
                          width: 24.0,
                        ),
                        const SizedBox(
                            width: 8), // Space between the icon and the text
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'PoppinsBold',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  result,
                  style: TextStyle(
                      fontFamily: 'PoppinsMedium', color: Color(0xffFF0000)),
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'PoppinsRegular'),
                      children: [
                        const TextSpan(text: "Don’t have an account yet? "),
                        TextSpan(
                          text: "Register",
                          style: const TextStyle(
                            color: Color(0xffC58BF2),
                            // Optional: to show the text as a link
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return RegisterScreen();
                                },
                              ));
                            },
                        ),
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
