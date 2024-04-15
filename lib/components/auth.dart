import 'package:car_management/pages/Login.dart';
import 'package:car_management/pages/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //logged in
          if(snapshot.hasData){
            return Homepage();
          }
          //not logged in
          else{
            return LoginPage();
          }
        },
      ),
    );
  }
}
