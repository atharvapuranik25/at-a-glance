import 'package:at_a_glance/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;
  late Position _currentPosition;
  String? _currentAddress;
  String? _currentCity;
  late String name;
  late String phone;
  late String image;

  FirebaseDatabase database = FirebaseDatabase.instance;

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
            onPressed: () {},
            icon: const Icon(
              Icons.chat_rounded,
              color: Colors.black,
            ),
          )
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
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF252525),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
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
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2196f3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
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
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFffa800),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
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
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          color: Color(0xFFf1f1f1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (currentIndex == 0) {
              //Services
              return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 10,
                        fit: FlexFit.loose,
                        child: Column(
                          children: [
                            const Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'What servies are you looking for',
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
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: () {},
                            child: const Text("Emergeny Services"),
                          ),
                        ),
                      )
                    ],
                  ));
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("User Profile"),
                                    Text("Edit or view your data"),
                                  ],
                                ),
                                const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              ],
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
                                      ),
                                      Text(user.email!),
                                      Text(phone),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                              ),
                              onPressed: () {},
                              child: const Text("+ Add Service"),
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
