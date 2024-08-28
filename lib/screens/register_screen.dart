import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:health_insight/screens/home_screen.dart';

import '../ui_helper/util.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  var fullName = TextEditingController();
  var uEmail = TextEditingController();
  var uMob = TextEditingController();
  var uPass = TextEditingController();
  bool showSpinner = false;

  //firebase
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  String encryptedText = '';
  String decryptedText = '';

  final keyData = encrypt.Key.fromUtf8('qwertyuiop');
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key.fromUtf8('qwertyuiopasdfghjklzxcvb')));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(),
      ),
      body: Container(
          height: double.infinity,
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hey there',
                  style: bodyTextStyle(),
                ),
                Text('Create an Account',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'PoppinsRegular'),
                        children: [
                      const TextSpan(text: 'Already Registered?  '),
                      TextSpan(
                        text: "Login",
                        style: const TextStyle(
                          color: Color(0xffC58BF2),
                          // Optional: to show the text as a link
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ));
                          },
                      ),
                    ])),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                        controller: fullName,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: Image.asset('assets/images/Profile.png'),
                          label: const Text(
                            'Full Name',
                            style: TextStyle(color: Color(0xffADA4A5)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        controller: uEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Image.asset('assets/images/Message.png'),
                          label: const Text(
                            'Email',
                            style: TextStyle(color: Color(0xffADA4A5)),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (value.length != 10) {
                            return 'Mobile number must be 10 digits long';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Mobile number must contain only digits';
                          }
                          return null;
                        },
                        controller: uMob,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Color(0xff7B6F72),
                          ),
                          label: const Text(
                            'Mobile',
                            style: TextStyle(color: Color(0xffADA4A5)),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                              .hasMatch(value)) {
                            return 'Minimum eight characters, \nat least one uppercase letter, \none lowercase letter, \none number and \none special character:';
                          }
                          return null;
                        },
                        controller: uPass,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          prefixIcon: Image.asset('assets/images/Lock.png'),
                          label: const Text(
                            'Password',
                            style: TextStyle(color: Color(0xffADA4A5)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.transparent),
                            shadowColor: WidgetStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              try {
                                UserCredential userCredential =
                                    await auth.createUserWithEmailAndPassword(
                                        email: uEmail.text,
                                        password: uPass.text);
                                user = userCredential.user;
                                await user!.updateDisplayName(fullName.text);
                                await user!.reload();
                                user = auth.currentUser;
                                if (user != null) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return HomeScreen();
                                    },
                                  ));
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  print('The password provided is too weak.');
                                } else if (e.code == 'email-already-in-use') {
                                  print(
                                      'The account already exists for that email.');
                                }
                              } catch (e) {
                                print(e);
                              }

                              // var name = fullName.text.toString();
                              // var email = uEmail.text.toString();
                              // var mobile = uMob.text.toString();
                              // var password = uPass.text.toString();
                              //
                              // final encrypted = encrypter.encrypt(password, iv: iv);
                              // setState(() {
                              //   encryptedText = encrypted.base64;
                              // });
                              //
                              // final decrypted = encrypter.decrypt(encrypted, iv: iv);
                              // setState(() {
                              //   decryptedText = decrypted;
                              // });
                            }
                          },
                          child: const Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'PoppinsBold',
                            ),
                          ),
                        ),
                      ),
                      if (encryptedText?.isNotEmpty ?? false)
                        Text('Encrypted Password: $encryptedText'),
                      if (decryptedText?.isNotEmpty ?? false)
                        Text('Decrypted Password: $decryptedText'),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
