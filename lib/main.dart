import 'package:car_management/components/LoginorRegister.dart';
import 'package:car_management/components/auth.dart';
import 'package:car_management/pages/Home.dart';
import 'package:car_management/pages/Login.dart';
import 'package:car_management/pages/Maintenance.dart';
import 'package:car_management/pages/Profile.dart';
import 'package:car_management/pages/Service_History.dart';
import 'package:car_management/pages/Simple_Diagnostic.dart';
import 'package:car_management/pages/Tracking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:car_management/components/globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //User details
  var userData;
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var user = _auth.currentUser;
  CollectionReference ref = firebaseFirestore.collection('users');
  var temp = ref.doc(user!.uid).get();
  temp.then((snapshot) {
    userData = snapshot.data();
    globals.userData = userData;
  });

  try {
    final firestoreURL = FirebaseStorage.instance
        .ref()
        .child('users/${FirebaseAuth.instance.currentUser!.uid}.png');
    String url = await firestoreURL.getDownloadURL();
    globals.profilePath = url;
  } catch (e) {
    print(e);
  }

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
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
