import 'dart:ffi';
import 'package:car_management/components/profile_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Center(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
          ),
          //Name
          Profile_List_Tile(tileName: "Name",),

          //Age
          Profile_List_Tile(tileName: "Age",),

          //Age
          Profile_List_Tile(tileName: "Gender",),
        ],
      ),
    ));
  }
}
