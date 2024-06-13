import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Set_MechanicPage extends StatefulWidget {
  const Set_MechanicPage({super.key});

  @override
  State<Set_MechanicPage> createState() => _Set_MechanicPageState();
}

class _Set_MechanicPageState extends State<Set_MechanicPage> {
  var mechanicID = [];

  Future<void> getMechanicID() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference ref = firebaseFirestore.collection('users');

    QuerySnapshot querySnapshot = await ref.get();

    querySnapshot.docs.forEach((element) {
      if (element['user'] == 'mechanic') {
        mechanicID.add(element.id);
      }
    });
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
                combinedData.add(value[value.length - 1]);
              }
            }

            print("data $data");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Color(0xFF3331c6),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Container(
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
                                      mechanicID
                                    ]);
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
