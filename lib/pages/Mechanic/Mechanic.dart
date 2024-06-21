import 'package:car_management/components/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MechanicPage extends StatefulWidget {
  const MechanicPage({super.key});

  @override
  State<MechanicPage> createState() => _MechanicPageState();
}

class _MechanicPageState extends State<MechanicPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var user = _auth.currentUser;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Mechanic Page',
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('scheduled_service')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(
                color: Color(0xFF3331c6),
              ));
            }

            final combinedData = [];
            final data = snapshot.data?.docs;

            for (var document in data! as List) {
              for (var value in document.data()!.values) {
                combinedData.add(value[value.length - 1]);
              }
            }
            
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                itemCount: combinedData.length,
                itemBuilder: (context, index) {
                  return combinedData[index]['mechanicID'] == user?.uid
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/maintenance_details',
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
