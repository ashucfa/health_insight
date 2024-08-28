import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_insight/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //Stop Watch
  late Stopwatch stopwatch;
  late Timer ti;

  //Stop watch function
  void handleStopStart() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
    } else {
      stopwatch.start();
    }
  }

  String returnFormattedText() {

    var milli = stopwatch.elapsed.inMilliseconds;
    String milliseconds = (milli % 1000).toString().padLeft(3, '0');
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, '0');

    return "$minutes:$seconds:$milliseconds";

  }

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      user = auth.currentUser;
    }

    stopwatch = Stopwatch();
    ti = Timer.periodic(Duration(microseconds: 30), (timer){
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        showExitDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ));
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('${user?.displayName}'),
                accountEmail: Text('${user?.email}'),
                currentAccountPicture: CircleAvatar(
                  child: Image.asset('assets/images/boy.png'),
                  backgroundColor: Colors.orange,
                ),
                otherAccountsPictures: <Widget>[
                  CircleAvatar(
                    child: Image.asset('assets/images/boy.png'),
                    backgroundColor: Colors.orange,
                  ),
                ],
                //onDetailsPressed: (){},
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.green),
                title: Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: 'QuicksandBold',
                  ),
                ),
                trailing: Icon(Icons.arrow_circle_right),
                onTap: () => {
                  // Close the drawer
                  Navigator.pop(context),
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.insert_drive_file_outlined, color: Colors.green),
                title: Text(
                  'About',
                  style: TextStyle(fontFamily: 'QuicksandBold'),
                ),
                trailing: Icon(Icons.arrow_circle_right),
                onTap: () => {
                  // Close the drawer
                  Navigator.pop(context),
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return Aboutscreen();
                  // },))
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.miscellaneous_services, color: Colors.green),
                title: Text(
                  'Services',
                  style: TextStyle(fontFamily: 'QuicksandBold'),
                ),
                trailing: Icon(Icons.arrow_circle_right),
                onTap: () => {
                  // Close the drawer
                  Navigator.pop(context),
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return Servicescreen();
                  // },))
                },
              )
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                handleStopStart();
              }, child: Text(returnFormattedText(),style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),

              SizedBox(height: 15,),

              CupertinoButton(     // this the cupertino button and here we perform all the reset button function
                onPressed: () {
                  stopwatch.reset();
                },
                padding: EdgeInsets.all(0),
                child: Text("Reset", style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Popup function
  Future<bool> showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Do you want to exit this app?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
