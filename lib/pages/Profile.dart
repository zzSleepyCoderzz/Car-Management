import 'dart:ffi';
import 'dart:io';

import 'package:car_management/components/auth.dart';
import 'package:car_management/components/globals.dart';
import 'package:car_management/components/profile_list_tile.dart';
import 'package:car_management/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:car_management/components/globals.dart' as globals;

Future<void> uploadProfilePicture() async {
  final ImagePicker _picker = ImagePicker();
  // Select image
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    File file = File(image.path);

    // Upload to Firebase
    try {
      await FirebaseStorage.instance
          .ref('users/${FirebaseAuth.instance.currentUser!.uid}.png')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("Error: $e");
    }
  }
  await Auth().userDetails();
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
              bottom: MediaQuery.of(context).size.height * 0.05,
            ),
            child: GestureDetector(
              onTap: () async {
                await uploadProfilePicture();

                setState(() {});
              },
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Center(
                    child: globals.profilePath != ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              globals.profilePath,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 50.0,
                            color: Colors.white,
                          )),
              ),
            ),
          ),
          //Name
          Profile_List_Tile(
            tileName: "Name",
          ),

          //Age
          Profile_List_Tile(
            tileName: "Age",
          ),

          //Age
          Profile_List_Tile(
            tileName: "Gender",
          ),
        ],
      ),
    ));
  }
}
