import 'package:car_management/pages/Login.dart';
import 'package:car_management/pages/Register.dart';
import 'package:flutter/material.dart';

class LoginorRegisterPage extends StatefulWidget {
  const LoginorRegisterPage({super.key});

  @override
  State<LoginorRegisterPage> createState() => _LoginorRegisterPageState();
}

class _LoginorRegisterPageState extends State<LoginorRegisterPage> {

  //initially show login page
  bool showLoginPage = true;
  //toggle between login and register
  void TogglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  } 
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTap: TogglePages);
    }
    else{
      return RegisterPage(onTap: TogglePages);
    }
  }
}