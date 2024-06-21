import 'dart:io';
import 'package:car_management/components/auth.dart';
import 'package:car_management/components/list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:car_management/components/globals.dart' as globals;

Future<void> uploadProfilePicture() async {
  final ImagePicker picker = ImagePicker();
  // Select image
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    File file = File(image.path);

    // Upload to Firebase
    try {
      await FirebaseStorage.instance
          .ref('users/${FirebaseAuth.instance.currentUser!.uid}.png')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      throw Exception(e.toString());
    }
  }
  await const Auth().userDetails();
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
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
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3331c6),
                ),
                child: Center(
                    child: globals.profilePath != ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              globals.profilePath,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 60.0,
                            color: Colors.white,
                          )),
              ),
            ),
          ),
          //Name
          const Profile_List_Tile(
            tileName: "Name",
          ),

          //Age
          const Profile_List_Tile(
            tileName: "Age",
          ),

          //Age
          const Profile_List_Tile(
            tileName: "Gender",
          ),
        ],
      ),
    ));
  }
}
