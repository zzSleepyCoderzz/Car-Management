import 'package:car_management/components/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Send message
  Future<void> sendMessage(String receiverID, String message) async {
    //get current user
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create new message
    Message msg = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    //construct chatroom ID using current user and receiver ID
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    //combine ids to make unique id
    String chatroomID = ids.join('_');

    //add msg to db
    await _firestore
        .collection('chatrooms')
        .doc(chatroomID)
        .collection('messages')
        .add(msg.toMap());
  }

  //Get message
  Stream<QuerySnapshot> getMessages(String senderID, String receiverID) {
    //construct chatroom ID using current user and receiver ID
    List<String> ids = [senderID, receiverID];
    ids.sort();
    //combine ids to make unique id
    String chatroomID = ids.join('_');

    //get messages from db
    return _firestore
        .collection('chatrooms')
        .doc(chatroomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}