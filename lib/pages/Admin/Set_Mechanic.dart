import 'package:car_management/components/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Set_MechanicPage extends StatefulWidget {
  const Set_MechanicPage({super.key});

  @override
  State<Set_MechanicPage> createState() => _Set_MechanicPageState();
}

class _Set_MechanicPageState extends State<Set_MechanicPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var user = _auth.currentUser;

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
                combinedData.add(value[value.length - 1]);
              }
            }

            return Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                itemCount: combinedData.length,
                itemBuilder: (context, index) {
                  print(combinedData[index]);
                  return combinedData[index]['mechanicID'] == '' &&
                          combinedData[index]['Car Model'] != ''
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                'set_mechanicbody',
                                arguments: combinedData[index],
                              );
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
          },
        ),
      ),
    );
  }
}

class Set_MechanicBody extends StatefulWidget {
  const Set_MechanicBody({super.key});

  @override
  State<Set_MechanicBody> createState() => _Set_MechanicBodyState();
}

Future getMechanicID() async {
  var mechanicID = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference ref = firebaseFirestore.collection('users');

  QuerySnapshot querySnapshot = await ref.get();
  querySnapshot.docs.forEach((element) {
    mechanicID.add(element.id);
  });
  return mechanicID;
}

class _Set_MechanicBodyState extends State<Set_MechanicBody> {
  var mechanicID = ['1', '2', '3'];
  String? selectedMechanic;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMechanicID(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          mechanicID = snapshot.data!.map<String>((e) => e.toString()).toList();

          print(mechanicID);
          return Scaffold(
            appBar: DefaultAppBar(
              title: 'Set Mechanic',
            ),
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      value: mechanicID[0],
                      hint: Text('Select Mechanic'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMechanic = newValue;
                        });
                      },
                      items: mechanicID
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
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
