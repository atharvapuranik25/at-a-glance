import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  int time = 5;

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: time),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TitlePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FlutterLogo(size: MediaQuery.of(context).size.height),
    );
  }
}
