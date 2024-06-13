import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  // Listen for changes in the emergency collection
  Stream<List> listenToEmergencyList() {
    return FirebaseFirestore.instance
        .collection('emergency')
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .map((snapshot) {
      List emergencyIds = [];
      for (var doc in snapshot.docs) {
        emergencyIds.add({
          'id': doc.id,
          'userID': doc['userID'],
        });
      }
      return emergencyIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    int _currentDocCount = 0;

    return StreamBuilder<List>(
      stream: listenToEmergencyList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(
                color: Color(0xFF3331c6),
              ));
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        //Checking if there are any changes
        if (snapshot.data!.length != _currentDocCount) {
          if (snapshot.data!.length > _currentDocCount) {
            _currentDocCount = snapshot.data!.length;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Emergency Request Alert"),
                    content: Text(
                        "There are current pending emergency requests. Please check the emergency page."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Close"),
                      ),
                    ],
                  );
                },
              );
            });
          } else {
            _currentDocCount = snapshot.data!.length;
          }
        }

        if (snapshot.data?.isEmpty ?? true) {
          return const Center(
              child: Text(
            'No pending emergency requests',
            style: TextStyle(
              fontSize: 16,
            ),
          ));
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors
                          .black, // Change this color to change the border color
                      width: 2,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Mark as Solved?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('emergency')
                                      .doc(snapshot.data![index]['id'])
                                      .update({
                                    'timeSolved': DateTime.now(),
                                    'status': 'Solved'
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text("Confirm"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      title: Text(snapshot.data![index]['userID']),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
