import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home_page.dart';
import 'main.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  late Position currentPosition;
  late String currentAddress;
  late String currentCity = "My City";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Please switch on your location");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location Permission Denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Permission Denied Forever");
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentPosition = position;
        currentCity = "${place.locality}";
        currentAddress =
            "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future authCheck() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "signup");
      } else {
        Navigator.pushReplacementNamed(context, "home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const HomePage();
                  } else {
                    return TitlePage(currentCity);
                  }
                }),
          ),
        ),
      ),
    );

    var assetsImage = const AssetImage(
        'images/flutter_logo.png'); //<- Creates an object that fetches an image.
    var image = Image(
        image: assetsImage,
        height: 300); //<- Creates a widget that displays an image.

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: Column(
              children: [Text(currentCity), image],
            ),
          ),
        ),
      ),
    );
    // return SplashScreen(
    //   seconds: 10,
    //   navigateAfterSeconds: authCheck(),
    //   // Navigator.pushReplacement(
    //   //   context,
    //   //   MaterialPageRoute(
    //   //     builder: (context) => Scaffold(
    //   //       body: StreamBuilder<User?>(
    //   //           stream: FirebaseAuth.instance.authStateChanges(),
    //   //           builder: (context, snapshot) {
    //   //             if (snapshot.hasData) {
    //   //               return const HomePage();
    //   //             } else {
    //   //               return const TitlePage();
    //   //             }
    //   //           }),
    //   //     ),
    //   //   ),
    //   // ),
    //   title: const Text(
    //     'At a Glance',
    //     textScaleFactor: 2,
    //   ),
    //   image: Image.network(
    //       'https://storage.googleapis.com/cms-storage-bucket/847ae81f5430402216fd.svg'),
    //   loadingText: Text(currentCity),
    //   photoSize: 100.0,
    //   loaderColor: Colors.blue,
    // );
  }
}
