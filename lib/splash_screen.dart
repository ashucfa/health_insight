import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_insight/screens/home_screen.dart';
import 'package:health_insight/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    WhereToGo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const String KEYLOGIN = "Login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }

  //Redirection Goes Here
  void WhereToGo() async {
    // Initialize FirebaseAuth
    FirebaseAuth auth = FirebaseAuth.instance;

    // Get SharedPreferences instance
    var sharedPref = await SharedPreferences.getInstance();

    // Check Firebase user authentication
    User? firebaseUser = auth.currentUser;

    // Navigate based on Firebase authentication status
    Timer(
      Duration(seconds: 3),
      () {
        if (firebaseUser != null) {
          // User is logged in with Firebase
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ));
        } else {
          // User is not logged in with Firebase, check SharedPreferences
          var isLoggedIn = sharedPref.getBool(KEYLOGIN);
          if (isLoggedIn != null && isLoggedIn) {
            // User is considered logged in but not authenticated with Firebase
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ));
          } else {
            // Navigate to LoginScreen if not authenticated
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return LoginScreen();
              },
            ));
          }
        }
      },
    );
  }
}
