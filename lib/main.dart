import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_insight/splash_screen.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Insight',
      theme: ThemeData(
          primaryColor: Colors.white,
          fontFamily: 'PoppinsRegular',
          textTheme: TextTheme(
            headlineLarge: TextStyle(fontFamily: 'PoppinsExtraBold'),
            headlineMedium: TextStyle(fontFamily: 'PoppinsBold'),
            headlineSmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
            titleLarge: TextStyle(fontFamily: 'PoppinsExtraBold'),
            titleMedium: TextStyle(fontFamily: 'PoppinsBold'),
            titleSmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
          )),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
    );
  }
}
