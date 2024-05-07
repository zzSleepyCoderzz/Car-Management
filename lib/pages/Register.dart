import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/button.dart';
import 'package:car_management/components/textfield.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // text editing controllers
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();
  bool _isLoading = false;

  // sign user in method
  void signUserUp() async {
    //try creating user
    try {
      //check if password is confirmed
      if (passwordController.text == confirmedPasswordController.text) {
        setState(() {
          _isLoading = true;
        });

        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
            .then((value) {
          postDetailsToFirestore();
        });

        //Choose profile image
        // Load default image from assets
        ByteData byteData = await rootBundle.load('assets/images/profile.jpg');
        Uint8List imageData = byteData.buffer.asUint8List();

        await FirebaseStorage.instance
            .ref('users/${FirebaseAuth.instance.currentUser!.uid}.png')
            .putData(imageData);

         //Throwing error
        _isLoading = false;

      } else {
        setState(() {
          _isLoading = false;
        });

        ErrorMsg("Passwords do not match");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      //Wrong email
      if (e.code == "user-not-found") {
        ErrorMsg(e.code);
      }
      //Wrong pass
      else if (e.code == "wrong-password") {
        ErrorMsg(e.code);
      } else {
        ErrorMsg(e.code);
      }
    }
  }

  //Create record in firestore
  void postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'email': emailController.text,
      'user': 'user',
      'Age': '0',
      'Name': 'User',
      'Gender': 'Non-binary',
    });

    CollectionReference ref1 = FirebaseFirestore.instance.collection('cars');
    ref1.doc(user.uid).set({
      'Car1': {
        'Car Model': 'Car1',
        'Pic':
            'https://images.unsplash.com/photo-1566008885218-90abf9200ddb?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'Number Plate': 'LIG 6969 MA'
      },
      'Car2': {
        'Car Model': 'Car2',
        'Pic':
            'https://images.unsplash.com/photo-1566008885218-90abf9200ddb?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'Number Plate': 'LIG 6969 MA'
      },
      'Car3': {
        'Car Model': 'Car3',
        'Pic':
            'https://images.unsplash.com/photo-1566008885218-90abf9200ddb?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'Number Plate': 'LIG 6969 MA'
      },
    });
  }

  void ErrorMsg(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
          );
        });
  }

  @override
  late AnimationController controller;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    opacityAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? Center(
            child: FadeTransition(
              opacity: opacityAnimation,
              child: const CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey[300],
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),

                    // logo
                    const Icon(
                      Icons.lock,
                      size: 70,
                    ),

                    const SizedBox(height: 25),

                    // welcome back, you've been missed!
                    Text(
                      'Let\'s create an account for you!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // email textfield
                    Textfield(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    Textfield(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 10),

                    // confirm password textfield
                    Textfield(
                      controller: confirmedPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 50),

                    // sign in button
                    LoginButton(
                      text: "Sign Up",
                      onTap: signUserUp,
                    ),

                    const SizedBox(height: 25),

                    // or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Sign in!',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
