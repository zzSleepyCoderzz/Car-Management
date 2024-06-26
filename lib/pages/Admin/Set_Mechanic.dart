import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/globals.dart' as globals;

class Set_MechanicPage extends StatefulWidget {
  const Set_MechanicPage({super.key});

  @override
  State<Set_MechanicPage> createState() => _Set_MechanicPageState();
}

class _Set_MechanicPageState extends State<Set_MechanicPage> {
  var mechanicID = [];
  List<String> mechanicName = [];

  Future<void> getMechanicID() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference ref = firebaseFirestore.collection('users');

    QuerySnapshot querySnapshot = await ref.get();

    for (var element in querySnapshot.docs) {
      if (element['user'] == 'mechanic') {
        mechanicID.add(element.id);
        mechanicName.add(element['Name']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Get List of all Mechanics
    getMechanicID();

    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('scheduled_service')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final combinedData = [];
            final data = snapshot.data?.docs;

            for (var document in data! as List) {
              for (var value in document.data()!.values) {
                if (value[value.length - 1]['mechanicID'] == '' &&
                    value[value.length - 1]['Car Model'] != '') {
                  combinedData.add(value[value.length - 1]);
                }
              }
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Color(0xFF3331c6),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (combinedData.isEmpty) {
              return const Text(
                'No pending service requests available.',
                style: TextStyle(
                  fontSize: 16,
                ),
              );
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.builder(
                  itemCount: combinedData.length,
                  itemBuilder: (context, index) {
                    return combinedData[index]['mechanicID'] == '' &&
                            combinedData[index]['Car Model'] != ''
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'set_mechanicbody',
                                    arguments: [
                                      combinedData[index],
                                    ]);
                                globals.mechanicList = [
                                  mechanicID,
                                  mechanicName
                                ];
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    combinedData[index]['Car Model'] == ''
                                        ? combinedData[index]['Car Number']
                                        : combinedData[index]['Car Model'],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
