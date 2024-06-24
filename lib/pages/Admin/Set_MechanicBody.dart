import 'package:car_management/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/globals.dart' as globals;

class Set_MechanicBody extends StatefulWidget {
  const Set_MechanicBody({super.key});

  @override
  State<Set_MechanicBody> createState() => _Set_MechanicBodyState();
}

class _Set_MechanicBodyState extends State<Set_MechanicBody> {
  var userData;
  List<String> mechanicID = List<String>.from(globals.mechanicList[0]);
  String? selectedMechanic = globals.mechanicList[0][0];
  List<String> mechanicName = List<String>.from(globals.mechanicList[1]);

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as List;

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('scheduled_service')
            .doc(data[0]['userID'])
            .get(),
        builder: (context, snapshot) {
          selectedMechanic = mechanicID[0];
          return Scaffold(
            appBar: AppBar(
              title: const Text("Set Mechanic"),
            ),
            body: Center(
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: selectedMechanic,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMechanic = newValue!;
                        print(selectedMechanic);
                      });
                    },
                    items: mechanicID.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text('$mechanicName'),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.1,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaintenanceButton(
                      onTap: () {
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
                     text: "Set Mechanic",
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
