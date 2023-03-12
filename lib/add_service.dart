import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

const List<String> service = <String>['Plumber', 'Electrician', 'Mechanic'];

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  ValueNotifier<GeoPoint?> notifier = ValueNotifier(null);

  final user = FirebaseAuth.instance.currentUser!;
  FirebaseDatabase database = FirebaseDatabase.instance;
  final storage = FirebaseStorage.instance;

  String dropdownValue = service.first;

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phnoController = TextEditingController();

  late final lattitude;
  late final longitude;

  String imageURL = '';

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phnoController.dispose();

    super.dispose();
  }

  Future addUserService() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("services/$dropdownValue");
    DatabaseReference userref = FirebaseDatabase.instance.ref("users");

    if (imageURL.isEmpty) {
      Fluttertoast.showToast(msg: "Please upload an image");
      return;
    }

    try {
      await ref.set({
        user.uid: {
          "name": nameController.text.trim(),
          "email": user.email,
          "phone": phnoController.text.trim(),
          "address": addressController.text.trim(),
          "lattitude": lattitude,
          "longitude": longitude,
          "image": imageURL,
        }
      });
      await userref.update({"${user.uid}/service": true});
      await userref.update({"${user.uid}/serice_type": dropdownValue});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Service'),
        ),
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blueAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items:
                        service.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Flexible(
                    child: Text(
                      "Add Service Name",
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
                        hintText: 'Enter Service Name',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Flexible(
                    child: Text(
                      "Add Service Address",
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
                      controller: addressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Service Address',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Flexible(
                    child: Text(
                      "Add Service Phone Number",
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
                        hintText: 'Enter Service Phone Number',
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

                      Reference storageRef = FirebaseStorage.instance.ref();
                      Reference imagesRef = storageRef.child("services");

                      Reference profileImageRef = imagesRef.child(user.uid);

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
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    onPressed: () async {
                      var p = await showSimplePickerLocation(
                        context: context,
                        isDismissible: true,
                        title: "Pick Location",
                        textConfirmPicker: "Pick",
                        initCurrentUserPosition: true,
                        initZoom: 16,
                        radius: 8.0,
                      );
                      if (p != null) {
                        notifier.value = p;
                        setState(() {
                          lattitude = p.latitude;
                          longitude = p.longitude;
                        });
                      }
                    },
                    child: const Text("Pick Custom Location"),
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
                          addUserService();
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
              )),
        ));
  }
}
