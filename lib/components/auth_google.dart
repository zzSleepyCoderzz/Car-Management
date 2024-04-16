import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class Google_Auth{
  
  signInWithGoogle() async {
    
    //begin interactive sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //obtain details from request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    //create new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //finally sign in user with credential
    return await FirebaseAuth.instance.signInWithCredential(credential);

}
}