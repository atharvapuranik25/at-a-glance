import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseDatabase database = FirebaseDatabase.instance;
  final storage = FirebaseStorage.instance;

  final nameController = TextEditingController();
  final phnoController = TextEditingController();

  String imageURL = '';

  @override
  void dispose() {
    nameController.dispose();
    phnoController.dispose();

    super.dispose();
  }

  Future addUserData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${user.uid}");

    if (imageURL.isEmpty) {
      Fluttertoast.showToast(msg: "Please upload an image");
      return;
    }

    try {
      await ref.set({
        "name": nameController.text.trim(),
        "email": user.email,
        "phone": phnoController.text.trim(),
        "image": imageURL,
        "service": false,
        "service_type": null
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    final snapshot = await ref.get();
    if (snapshot.exists) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, "home");
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, "addData");
    }
  }

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
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
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
                              hintText: user.email,
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
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: TextField(
                            controller: phnoController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Phone Number',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Flexible(
                          child: Text(
                            "Pick a Profile Picture",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        IconButton(
                          icon: const Icon(Icons.image),
                          iconSize: 30,
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery);

                            if (file == null) return;

                            Reference storageRef =
                                FirebaseStorage.instance.ref();
                            Reference imagesRef = storageRef.child("users");

                            Reference profileImageRef =
                                imagesRef.child(user.uid);

                            try {
                              await profileImageRef.putFile(File(file.path));
                              imageURL = await profileImageRef.getDownloadURL();
                            } catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          },
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
                                addUserData();
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
