import 'dart:io';
import 'package:car_management/components/appbar.dart';
import 'package:car_management/components/auth.dart';
import 'package:car_management/components/button.dart';
import 'package:car_management/components/list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';

Future<void> uploadInvoice(String UserUID, String CarNumber) async {
  final ImagePicker picker = ImagePicker();
  // Select image
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    File file = File(image.path);

    // Upload to Firebase
    try {
      await FirebaseStorage.instance
          .ref(
              'invoices/${FirebaseAuth.instance.currentUser!.uid}/$UserUID/$CarNumber.png')
          .putFile(file);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
  await const Auth().userDetails();
}

//update records in firestore
void postDetailsToFirestore(var value, String user) {
  CollectionReference ref =
      FirebaseFirestore.instance.collection('scheduled_service');
  ref.doc(user).update(value);
}

class Update_Service_HistoryPage extends StatefulWidget {
  const Update_Service_HistoryPage({super.key});

  @override
  State<Update_Service_HistoryPage> createState() =>
      _Update_Service_HistoryPageState();
}

class _Update_Service_HistoryPageState
    extends State<Update_Service_HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Update Service History',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Update_Maintenance_List_Tile(
                tileName: "Mileage",
                value: data['Car Number'],
                userID: data['userID'],
              ),
              Update_Maintenance_List_Tile(
                tileName: "Engine Oil",
                value: data['Car Number'],
                userID: data['userID'],
              ),
              Update_Maintenance_List_Tile(
                tileName: "Brake Pads",
                value: data['Car Number'],
                userID: data['userID'],
              ),
              Update_Maintenance_List_Tile(
                tileName: "Air Filter",
                value: data['Car Number'],
                userID: data['userID'],
              ),
              Update_Maintenance_List_Tile(
                tileName: "Alignment",
                value: data['Car Number'],
                userID: data['userID'],
              ),
              Update_Maintenance_List_Tile(
                tileName: "Battery",
                value: data['Car Number'],
                userID: data['userID'],
              ),
              Update_Maintenance_List_Tile(
                tileName: "Coolant",
                value: data['Car Number'],
                userID: data['userID'],
              ),
              Update_Maintenance_List_Tile(
                tileName: "Spark Plugs",
                value: data['Car Number'],
                userID: data['userID'],
              ),
              Update_Maintenance_List_Tile(
                tileName: "Tyres",
                value: data['Car Number'],
                userID: data['userID'],
              ),
              Update_Maintenance_List_Tile(
                tileName: "Transmission Fluid",
                value: data['Car Number'],
                userID: data['userID'],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              MaintenanceButton(
                 onTap: () {
                    uploadInvoice(data['userID'], data['Car Number']);
                    globals.scheduledService[data['Car Number']].add({
                      'userID': data['userID'],
                      'Car Number': data['Car Number'],
                      'Car Model': '',
                      'Date': '',
                      'Timeslot': '',
                      'Remarks': '',
                      'mechanicID': '',
                      'Invoice': '',
                    });
                    postDetailsToFirestore(
                        globals.scheduledService, data['userID']);
                    setState(() {
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // Prevents the dialog from closing when tapping outside
                        builder: (BuildContext context) {
                          //Loading dialog
                          return const AlertDialog(
                            content: SizedBox(
                              height: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Color(0xFF3331c6)
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Add some spacing between the CircularProgressIndicator and the text
                                  Text("Loading..."),
                                ],
                              ),
                            ),
                          );
                        },
                      );
        
                      //Wait for some time before going to next page
                      Future.delayed(const Duration(seconds: 7), () {
                        //Remove all other pages in the stack
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    });
                  },
                  text: "Upload Invoice",),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            ],
          ),
        ),
      ),
    );
  }
}
