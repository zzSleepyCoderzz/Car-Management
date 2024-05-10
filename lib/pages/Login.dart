import 'package:car_management/components/auth_google.dart';
import 'package:car_management/pages/Home.dart';
import 'package:car_management/pages/Mechanic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/button.dart';
import 'package:car_management/components/textfield.dart';
import 'package:car_management/components/square_tile.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final forgotPasswordController = TextEditingController();
  bool _isLoading = false;

  // sign user in method
  void signUserIn() async {
    //try sign in
    try {
      setState(() {
        _isLoading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //check if widget has been disoseed yet
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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

  //Error Popup
  void ErrorMsg(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
          );
        });
  }

  //Forgot pass function
  Future forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    } catch (err) {
      throw Exception(err.toString());
    }
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
                    const SizedBox(height: 50),

                    // logo
                    const Icon(
                      Icons.lock,
                      size: 70,
                    ),

                    const SizedBox(height: 50),

                    // welcome back, you've been missed!
                    Text(
                      'Welcome back you\'ve been missed!',
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

                    // forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Center(
                                          child: Text(
                                              "A link will be sent to reset your password")),
                                      content: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  forgotPasswordController,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    "Enter and Confirm your email",
                                              ),
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  if (forgotPasswordController
                                                      .text.isEmpty) {
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 300));
                                                    Navigator.pop(context);
                                                  } else {
                                                    forgotPassword(
                                                        email:
                                                            forgotPasswordController
                                                                .text);
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: const Text(
                                                    "Reset Password"))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    LoginButton(
                      text: "Sign In",
                      onTap: signUserIn,
                    ),

                    const SizedBox(height: 50),

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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
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

                    // google + apple sign in buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // google button
                        SquareTile(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  });
                              await Future.delayed(const Duration(seconds: 2));
                              Google_Auth().signInWithGoogle();
                              Navigator.pop(context);
                            },
                            imagePath: "assets/images/google.png"),

                        const SizedBox(width: 25),

                        // apple button
                        SquareTile(
                            onTap: () {}, imagePath: 'assets/images/apple.png')
                      ],
                    ),

                    const SizedBox(height: 25),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Register now!',
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
