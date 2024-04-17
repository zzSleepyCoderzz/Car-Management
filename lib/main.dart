import 'package:car_management/components/auth.dart';
import 'package:car_management/pages/Home.dart';
import 'package:car_management/pages/Maintenance.dart';
import 'package:car_management/pages/Profile.dart';
import 'package:car_management/pages/Tracking.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final GoRouter _goRouter = GoRouter(routes: [
  GoRoute(path: "/", 
   builder: (context, state) => const Auth()),
  GoRoute(path: "/home", 
   builder: (context, state) => const HomePage()),
   GoRoute(path: "/profile", 
   builder: (context, state) => const ProfilePage()),
   GoRoute(path: "/maintenance", 
   builder: (context, state) => const MaintenancePage()),
]);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _goRouter,
    );
  }
}
