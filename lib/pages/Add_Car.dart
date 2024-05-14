import 'dart:io';
import 'package:car_management/components/auth.dart';
import 'package:car_management/components/list_tile.dart';
import 'package:car_management/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:car_management/components/globals.dart' as globals;



Future<void> uploadCarPicture(String data) async {
  final _auth = FirebaseAuth.instance;
  var user = _auth.currentUser;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference ref = firebaseFirestore.collection('cars');

  final ImagePicker _picker = ImagePicker();
  // Select image
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    File file = File(image.path);

    // Upload to Firebase
    try {
      // Upload file
      await FirebaseStorage.instance
          .ref('cars/${FirebaseAuth.instance.currentUser!.uid}${data}.png')
          .putFile(file);

      // Get url
      final firestoreURL = FirebaseStorage.instance
          .ref()
          .child('cars/${FirebaseAuth.instance.currentUser!.uid}${data}.png');
      String url = await firestoreURL.getDownloadURL();

      //Set the globals variable to the url
      globals.carData[data]['Pic'] = url;

      // Update Firebase
      ref.doc(user!.uid).update({data: globals.carData[data]});
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("Error: $e");
    }
  }
  await Auth().userDetails();
}

class Add_CarPage extends StatefulWidget {
  const Add_CarPage({super.key});

  @override
  State<Add_CarPage> createState() => _Add_CarPageState();
}

class _Add_CarPageState extends State<Add_CarPage> {
  Widget build(BuildContext context) {
    //Getting data from Navigator
    final data = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Tune Up Garage'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
              );
            },
          ),
        ),
        body: Center(
          child: Column(
            children: [
              //Car Picture
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                  bottom: MediaQuery.of(context).size.height * 0.05,
                ),
                child: GestureDetector(
                  onTap: () async {
                    try {
                      await uploadCarPicture(data.toString())
                          .then((value) => {setState(() {})});
                    } catch (e) {
                      print("Error ${e}");
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: globals.carData[data]['Pic'] != ''
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  globals.carData[data]['Pic'],
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.car_rental,
                                size: 50.0,
                                color: Colors.white,
                              )),
                  ),
                ),
              ),

              Add_Car_ListTile(
                tileName: "Car Model",
                carModel: data.toString(),
              ),
              Add_Car_ListTile(
                tileName: "Number Plate",
                carModel: data.toString(),
              ),
            ],
          ),
        ));
  }
}
