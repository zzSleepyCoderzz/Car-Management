import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/button.dart';
import 'package:car_management/components/textfield.dart';

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
        ErrorMsg("User Not Found!");
      }

      //Wrong pass
      else if (e.code == "invalid-credential") {
        ErrorMsg("Wrong Password!");
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
            title: Text(
              msg,
              style: const TextStyle(fontSize: 24),
            ),
          );
        });
  }

  //Forgot pass function
  Future forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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
              child: const CircularProgressIndicator(
                color: Color(0xFF3331c6),
              ),
            ),
          )
        : Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xFF3331c6),
                  ], // Example gradient colors
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),

                      // logo
                      const Icon(
                        Icons.car_repair_sharp,
                        size: 100,
                      ),

                      const SizedBox(height: 35),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Welcome to ',
                            ),
                            TextSpan(
                              text: 'Tune Up!',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' The Premier',
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Car Management System',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 50),

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
                                        content: Column(
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
                                                    //Pop if there the current page is mounted
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                    }
                                                  } else {
                                                    forgotPassword(
                                                        email:
                                                            forgotPasswordController
                                                                .text);
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    //Pop if there the current page is mounted
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                    "Reset Password"))
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),

                      // sign in button
                      LoginButton(
                        text: "Sign In",
                        onTap: signUserIn,
                      ),

                      const SizedBox(height: 50),

                      // // or continue with
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: Divider(
                      //           thickness: 0.5,
                      //           color: Colors.grey[400],
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 10.0),
                      //         child: Text(
                      //           'Or continue with',
                      //           style: TextStyle(color: Colors.grey[700]),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: Divider(
                      //           thickness: 0.5,
                      //           color: Colors.grey[400],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // google + apple sign in buttons
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     // google button
                      //     SquareTile(
                      //         onTap: () async {
                      //           showDialog(
                      //               context: context,
                      //               builder: (context) {
                      //                 return const Center(
                      //                     child: CircularProgressIndicator(
                      //                   color: Color(0xFF3331c6),
                      //                 ));
                      //               });
                      //           await Future.delayed(const Duration(seconds: 2));
                      //           Google_Auth().signInWithGoogle();
                      //           Navigator.pop(context);
                      //         },
                      //         imagePath: "assets/images/google.png"),

                      //     const SizedBox(width: 25),

                      //     // apple button
                      //     SquareTile(
                      //         onTap: () {}, imagePath: 'assets/images/apple.png')
                      //   ],
                      // ),

                      // const SizedBox(height: 25),

                      // not a member? register now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Not a member?',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Register now!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 28, 210, 255),
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
            ),
          );
  }
}
