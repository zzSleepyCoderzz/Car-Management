import 'package:car_management/components/LoginorRegister.dart';
import 'package:car_management/pages/Admin/Admin.dart';
import 'package:car_management/pages/Home.dart';
import 'package:car_management/pages/Mechanic/Mechanic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/globals.dart' as globals;

class Auth extends StatelessWidget {
  const Auth({super.key});

  Future<void> userDetails() async {
    var userData;
    var carData;
    var serviceData;
    var fuelData;
    var scheduledService;
    final _auth = FirebaseAuth.instance;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = firebaseFirestore.collection('users');
    CollectionReference ref1 = firebaseFirestore.collection('cars');
    CollectionReference ref2 = firebaseFirestore.collection('service');
    CollectionReference ref3 = firebaseFirestore.collection('fuel');
    CollectionReference ref4 = firebaseFirestore.collection('scheduled_service');

    //adding user data to global variable
    var temp = ref.doc(user!.uid).get();
    temp.then((snapshot) {
      userData = snapshot.data();
      globals.userData = userData;
    });

    //adding car data to global variable
    var temp1 = ref1.doc(user.uid).get();
    temp1.then((snapshot) {
      carData = snapshot.data();
      globals.carData = carData;
    });

    //adding service data to global variable
    var temp2 = ref2.doc(user.uid).get();
    temp2.then((snapshot) {
      serviceData = snapshot.data();
      globals.serviceData = serviceData;
    });

    //adding fuel data to global variable
    var temp3 = ref3.doc(user.uid).get();
    temp3.then((snapshot) {
      fuelData = snapshot.data();
      globals.fuelData = fuelData;
    });

    //adding scheduledService data to global variable
    var temp4 = ref4.doc(user.uid).get();
    temp4.then((snapshot) {
      scheduledService = snapshot.data();
      globals.scheduledService = scheduledService;
    });


    //Ensure no error thrown when user has no profile picture
    try {
      try {
        final firestoreURL = FirebaseStorage.instance
            .ref()
            .child('users/${FirebaseAuth.instance.currentUser!.uid}.png');
        String url = await firestoreURL.getDownloadURL();
        globals.profilePath = url;
      } catch (e) {
        print("Error: $e");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // seperating users by role
            if (snapshot.hasData) {
              userDetails();
              User? user = FirebaseAuth.instance.currentUser;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(); // or some other widget while waiting
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    //send normal user to User Interface
                    //Cant run userDetails here since it takes time to complete
                    if (snapshot.data!['user'] == "user") {
                      return const HomePage();
                    }
                    //send Mechanic to mechanic Interface
                    else if (snapshot.data!['user'] == "mechanic") {
                      return const MechanicPage();
                    }
                    //send Admin to Admin Interface
                    else if (snapshot.data!['user'] == "admin") {
                      return const AdminPage();
                    } else {
                      return const LoginorRegisterPage();
                    }
                  }
                },
              );
            } else {
              return LoginorRegisterPage();
            }
          }),
    );
  }
}
