import 'package:car_management/components/LoginorRegister.dart';
import 'package:car_management/components/auth.dart';
import 'package:car_management/pages/Add_Car.dart';
import 'package:car_management/pages/Admin/Admin_Chat.dart';
import 'package:car_management/pages/Fuel_Consumption.dart';
import 'package:car_management/pages/Home.dart';
import 'package:car_management/pages/Maintenance.dart';
import 'package:car_management/pages/Mechanic/Maintenance_Details.dart';
import 'package:car_management/pages/Mechanic/Mechanic.dart';
import 'package:car_management/pages/Mechanic/Update_Service_History.dart';
import 'package:car_management/pages/Profile.dart';
import 'package:car_management/pages/Schedule_Service.dart';
import 'package:car_management/pages/Service_History.dart';
import 'package:car_management/pages/Simple_Diagnostic.dart';
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
        '/service_history': (context) => const Service_HistoryPage(),
        '/simple_diagnostics': (context) => const Simple_DiagnosticPage(),
        '/schedule_service': (context) => const Schedule_ServicePage(),
        '/fuel_consumption': (context) => const Fuel_ConsumptionPage(),
        '/add_car': (context) => const Add_CarPage(),
        '/admin_chat': (context) => const Admin_ChatPage(),
        '/mechanic':(context) => const MechanicPage(),
        '/maintenance_details': (context) => const Maintenance_DetailsPage(),
        '/update_service_history': (context) => const Update_Service_HistoryPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
