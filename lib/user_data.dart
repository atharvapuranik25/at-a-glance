import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Starting_page_1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Flexible(
                  //title
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "At A Glance",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.loose,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(
                          child: Text(
                            "Enter Name",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Name',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Flexible(
                          child: Text(
                            "Email Address",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: user.email!,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Flexible(
                          child: Text(
                            "Enter Phone Number",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Phone Number',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, "home");
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
