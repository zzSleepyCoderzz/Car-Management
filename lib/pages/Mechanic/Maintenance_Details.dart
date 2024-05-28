import 'package:car_management/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/globals.dart' as globals;

class Maintenance_DetailsPage extends StatefulWidget {
  const Maintenance_DetailsPage({super.key});

  @override
  State<Maintenance_DetailsPage> createState() =>
      _Maintenance_DetailsPageState();
}



class _Maintenance_DetailsPageState extends State<Maintenance_DetailsPage> {

  Future<void> getServiceHistory(String userID) async {
    var serviceHistory;
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    CollectionReference ref = firebaseFirestore.collection('service');

    //adding service history to global variable
    var temp = ref.doc(userID).get();
    temp.then((snapshot) {
      serviceHistory = snapshot.data();
      globals.serviceHistory = serviceHistory;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as MapEntry;

    return FutureBuilder(
      future: getServiceHistory(data.value[0]['userID']),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Maintenance Details'),
          ),
          body: Column(
            children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        "DATE: ${data.value[0]['Date']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "TIME:  ${data.value[0]['Timeslot']}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("Remarks to Mechanic: \n  ${data.value[0]['Remarks']}",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.2,),
            MaintenanceButton(onTap: (){
              Navigator.pushNamed(context, '/update_service_history', arguments: data.value[0]);
            }, text: "Complete Maintenance"),
          ]),
        );
      }
    );
  }
}