import 'package:car_management/components/LoginorRegister.dart';
import 'package:car_management/pages/Login.dart';
import 'package:car_management/pages/Home.dart';
import 'package:car_management/pages/Mechanic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {

            // seperating users by role
            if (snapshot.hasData) {
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
                    if (snapshot.data!['user'] == "user") {
                      return const HomePage();

                    //send Mechanic ro mechanic Interface
                    } else if (snapshot.data!['user'] == "mechanic") {
                      return const MechanicPage();
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
