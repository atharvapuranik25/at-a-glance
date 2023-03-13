import 'dart:async';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:at_a_glance/chat_screen.dart';
import 'package:at_a_glance/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'add_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;
  DateTime now = DateTime.now();
  late int hours;

  late Position _currentPosition;
  late String _currentAddress = 'Getting Address';
  String? _currentCity;

  late String name = 'Getting Name';
  late String phone = 'Getting Number';
  late String image;
  double lattitude = 0;
  double longitude = 0;
  late String service = 'false';
  late String serviceType = 'Getting Service Type';

  late String serviceName = 'Getting Name';
  late String serviceAddress = 'Getting Service Address';
  late String servicePhone = 'Getting Number';
  late String serviceImage;

  late String diesel = '';
  late String petrol = '';
  late String tempType = '';
  late String temp = '';
  late String windSpeed = '';
  late String windType = '';
  late String aqi = '';
  late String aqiType = '';

  FirebaseDatabase database = FirebaseDatabase.instance;

  Query serviceRef = FirebaseDatabase.instance.ref().child('services');

  DatabaseReference serviceprovref =
      FirebaseDatabase.instance.ref().child('services');

  Query newsRef =
      FirebaseDatabase.instance.ref().child('city_news').child('Ujjain');
  DatabaseReference newRef =
      FirebaseDatabase.instance.ref().child('city_news').child('Ujjain');

  Future<String> getDistance(
      double lat1, double long1, double lat2, double long2) async {
    double distanceEnMeters = await distance2point(
      GeoPoint(
        longitude: long1,
        latitude: lat1,
      ),
      GeoPoint(
        longitude: long2,
        latitude: lat2,
      ),
    );
    String distance;
    distance = distanceEnMeters.toString();

    return distance;
  }

  Widget listItem({required Map service}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        //show service
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(service['image']),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['name'],
                  overflow: TextOverflow.visible,
                ),
                Text(
                  service['service_type'],
                  overflow: TextOverflow.visible,
                ),
                Text(
                  service['address'],
                  overflow: TextOverflow.visible,
                ),
                Text(
                  service['phone'],
                  overflow: TextOverflow.visible,
                ),
                // const Text("2.3km Away"),
                // FutureBuilder(
                //   builder: (context, service) {
                //     return const Center(
                //       child: CircularProgressIndicator(),
                //     );
                //   },
                //   future: getDistance(
                //     lattitude,
                //     longitude,
                //     service['lattitude'],
                //     service['longitude'],
                //   ), //get back to this
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget newsItem({required Map article}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        //show service
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(article['image']),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Container(
                child: Text(
                  article['headline'],
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
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

    setState(() {
      longitude = position.longitude;
      lattitude = position.latitude;
    });

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentPosition = position;
        _currentCity = "${place.locality}";
        _currentAddress =
            "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference nameref =
        FirebaseDatabase.instance.ref("users/${user.uid}/name");
    nameref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        name = data.toString();
        hours = now.hour;
      });
    });
    DatabaseReference phnoref =
        FirebaseDatabase.instance.ref("users/${user.uid}/phone");
    phnoref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        phone = data.toString();
      });
    });
    DatabaseReference imgref =
        FirebaseDatabase.instance.ref("users/${user.uid}/image");
    imgref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        image = data.toString();
      });
    });
    DatabaseReference serviceref =
        FirebaseDatabase.instance.ref("users/${user.uid}/service");
    serviceref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        service = data.toString();
      });
    });
    DatabaseReference servicetyperef =
        FirebaseDatabase.instance.ref("users/${user.uid}/serice_type");
    servicetyperef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        serviceType = data.toString();
      });
    });
    DatabaseReference servicenameref =
        FirebaseDatabase.instance.ref("services/${user.uid}/name");
    servicenameref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        serviceName = data.toString();
      });
    });
    DatabaseReference servicepnoref =
        FirebaseDatabase.instance.ref("services/${user.uid}/phone");
    servicepnoref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        servicePhone = data.toString();
      });
    });
    DatabaseReference serviceaddressref =
        FirebaseDatabase.instance.ref("services/${user.uid}/address");
    serviceaddressref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        serviceAddress = data.toString();
      });
    });
    DatabaseReference serviceimgref =
        FirebaseDatabase.instance.ref("services/${user.uid}/image");
    serviceimgref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        serviceImage = data.toString();
      });
    });
    DatabaseReference petrolref =
        FirebaseDatabase.instance.ref("city_data/Ujjain/petrol");
    petrolref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        petrol = data.toString();
      });
    });
    DatabaseReference dieselref =
        FirebaseDatabase.instance.ref("city_data/Ujjain/diesel");
    dieselref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        diesel = data.toString();
      });
    });
    DatabaseReference tempref =
        FirebaseDatabase.instance.ref("city_data/Ujjain/temperature");
    tempref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        temp = data.toString();
      });
    });
    DatabaseReference temptyperef =
        FirebaseDatabase.instance.ref("city_data/Ujjain/temp_type");
    temptyperef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        tempType = data.toString();
      });
    });
    DatabaseReference windref =
        FirebaseDatabase.instance.ref("city_data/Ujjain/wind_speed");
    windref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        windSpeed = data.toString();
      });
    });
    DatabaseReference windtyperef =
        FirebaseDatabase.instance.ref("city_data/Ujjain/wind_type");
    windtyperef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        windType = data.toString();
      });
    });
    DatabaseReference aqiref =
        FirebaseDatabase.instance.ref("city_data/Ujjain/aqi");
    aqiref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        aqi = data.toString();
      });
    });
    DatabaseReference aqityperef =
        FirebaseDatabase.instance.ref("city_data/Ujjain/aqi_type");
    aqityperef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        aqiType = data.toString();
      });
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _currentCity != null
            ? RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: _currentCity,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text: "\nAt A Glance",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              )
            : RichText(
                textAlign: TextAlign.start,
                text: const TextSpan(
                  text: "Your City",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "\nAt A Glance",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            icon: const Icon(
              Icons.chat_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (currentIndex == 1) {
              //Home
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFf1f1f1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(14),
                          ),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF252525),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Petrol",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$petrol/L',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(
                                        color: Colors.white38,
                                        thickness: 3,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Diesel",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$diesel/L',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2196f3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  hours >= 4 && hours < 18
                                                      ? const Icon(
                                                          Icons.sunny,
                                                          size: 20,
                                                          color: Colors.yellow,
                                                        )
                                                      : const Icon(
                                                          Icons.dark_mode,
                                                          size: 20,
                                                          color: Colors.white,
                                                        ),
                                                  Text(
                                                    '$temp°C',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            tempType,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(
                                        color: Colors.white38,
                                        thickness: 3,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Icon(
                                                Icons.wind_power,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                '${windSpeed}Km/h',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            windType,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFffa800),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: const [
                                                  Icon(
                                                    Icons.air,
                                                    size: 20,
                                                    color: Colors.yellow,
                                                  ),
                                                  Text(
                                                    'AQI',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            aqi,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(
                                        color: Colors.white38,
                                        thickness: 3,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            aqiType,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      flex: 5,
                      fit: FlexFit.loose,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFf1f1f1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: FirebaseAnimatedList(
                          query: newsRef,
                          itemBuilder: (BuildContext context,
                              DataSnapshot snapshot,
                              Animation<double> animation,
                              int index) {
                            Map article = snapshot.value as Map;
                            article['key'] = snapshot.key;

                            return newsItem(article: article);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (currentIndex == 0) {
              //Services
              return Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: FirebaseAnimatedList(
                  query: serviceRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map serviceProvider = snapshot.value as Map;
                    serviceProvider['key'] = snapshot.key;

                    return listItem(service: serviceProvider);
                  },
                ),

                // Column(
                //   children: [
                //     const TextField(
                //       decoration: InputDecoration(
                //         border: OutlineInputBorder(),
                //         hintText: 'What servies are you looking for',
                //       ),
                //     ),
                //     const SizedBox(
                //       height: 10,
                //     ),
                //     Container(
                //       constraints: const BoxConstraints.expand(),
                //       padding: const EdgeInsets.all(20),
                //       decoration: const BoxDecoration(
                //         color: Color(0xFFf1f1f1),
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(14),
                //         ),
                //       ),
                //       child: FirebaseAnimatedList(
                //         query: elecRef,
                //         itemBuilder: (BuildContext context,
                //             DataSnapshot snapshot,
                //             Animation<double> animation,
                //             int index) {
                //           Map electrician = snapshot.value as Map;
                //           electrician['key'] = snapshot.key;

                //           return listItem(service: electrician);
                //         },
                //       ),
                //     ),
                //     // ElevatedButton(
                //     //   style: ElevatedButton.styleFrom(
                //     //     backgroundColor: Colors.redAccent,
                //     //   ),
                //     //   onPressed: () {},
                //     //   child: const Text("Emergeny Services"),
                //     // ),
                //   ],
                // ),
              );
            } else if (currentIndex == 2) {
              //Search
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Whats on your mind today?',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFf1f1f1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (currentIndex == 3) {
              //Profile
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFf1f1f1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "User Profile",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(image),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        user.email!,
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        phone,
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        _currentAddress,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            service == 'false'
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AddService()),
                                      );
                                      const AddService();
                                    },
                                    child: const Text("+ Add Service"),
                                  )
                                : Column(
                                    children: [
                                      const Text(
                                        "Service Profile",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        //show service
                                        padding: const EdgeInsets.all(15),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF252525),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 50,
                                              backgroundImage:
                                                  NetworkImage(serviceImage),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  serviceName,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  serviceType,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  serviceAddress,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  servicePhone,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () {
                                signOut();
                              },
                              child: const Text("LogOut"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: 'Services',
            icon: Icon(Icons.people),
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    if (FirebaseAuth.instance.currentUser != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomePage(),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        ),
      );
    }
  }
}
