import 'package:car_management/components/LoginorRegister.dart';
import 'package:car_management/components/auth.dart';
import 'package:car_management/pages/Home.dart';
import 'package:car_management/pages/Login.dart';
import 'package:car_management/pages/Maintenance.dart';
import 'package:car_management/pages/Profile.dart';
import 'package:car_management/pages/Tracking.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Auth(),
        '/login': (context) => const LoginorRegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/maintenance': (context) => const MaintenancePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
