import 'dart:async';

import 'package:car_management/components/appbar.dart';
import 'package:car_management/components/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('scheduled_service')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final combinedData = [];
                final data = snapshot.data?.docs;

                for (var document in data!) {
                  for (var value in document.data().entries) {
                    combinedData.add(value);
                    print(combinedData);
                  }
                }

                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                      itemCount: combinedData.length,
                      itemBuilder: (context, index) {
                       
                        return combinedData[index].value[0]['mechanicID'] == user?.uid ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/maintenance_details',
                                  arguments: combinedData[index]);
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
                                title: Text(combinedData[index].value[0]
                                            ['Car Model'] ==
                                        ''
                                    ? combinedData[index].key
                                    : combinedData[index].value[0]['']),
                              ),
                            ),
                          ),
                        ) : Container();
                      }),
                );
              }),
        ));
  }
}
