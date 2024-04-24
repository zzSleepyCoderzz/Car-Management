import 'package:car_management/components/auth_google.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/my_button.dart';
import 'package:car_management/components/my_textfield.dart';
import 'package:car_management/components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  // sign user in method
  void signUserUp() async {
    //loading
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    //try creating user
    try {
      //check if password is confirmed
      if (passwordController.text == confirmedPasswordController.text) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
            .then((value) {
          postDetailsToFirestore();
          Navigator.popAndPushNamed(context, '/login');
        });
      } else {
        Navigator.pop(context);
        ErrorMsg("Passwords do not match");
      }

      

    } on FirebaseAuthException catch (e) {
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

      //Pop Loading Circle
      Navigator.pop(context);
    }
  }

  //Create record in firestore
  void postDetailsToFirestore() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({'email': emailController.text, 'user': 'user'});
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
  Widget build(BuildContext context) {
    return Scaffold(
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
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // confirm password textfield
              MyTextField(
                controller: confirmedPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 50),

              // sign in button
              MyButton(
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
