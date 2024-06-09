import 'package:car_management/components/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Set_MechanicBody extends StatefulWidget {
  const Set_MechanicBody({super.key});

  @override
  State<Set_MechanicBody> createState() => _Set_MechanicBodyState();
}

class _Set_MechanicBodyState extends State<Set_MechanicBody> {
  var userData;
  List<String> mechanicID = [];
  String? selectedMechanic;

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as List;

    //converting List<dynamic> to List<String>
    mechanicID = List<String>.from(data[1]);

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('scheduled_service')
            .doc(data[0]['userID'])
            .get(),
        builder: (context, snapshot) {
          selectedMechanic = mechanicID[0];

          return Scaffold(
            appBar: AppBar(
              title: Text("Set Mechanic"),
            ),
            body: Center(
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: selectedMechanic,
                    items: mechanicID.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      selectedMechanic = val;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //Assign snapshot to userData
                        userData = snapshot.data!.data()!;
                        userData[data[0]['Car Number']]
                                [userData[data[0]['Car Number']].length - 1]
                            ['mechanicID'] = selectedMechanic;

                        //Update Firebase
                        FirebaseFirestore.instance
                            .collection('scheduled_service')
                            .doc(data[0]['userID'])
                            .update(userData);

                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('Set Mechanic'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
