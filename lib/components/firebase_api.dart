
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseAPI{
  final _firebaseMessaging = FirebaseMessaging.instance;
  
  Future<void> initNotif() async {
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken();
  } 
}