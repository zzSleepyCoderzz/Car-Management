import 'package:car_management/components/chat_service.dart';
import 'package:car_management/components/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Admin_ChatPage extends StatefulWidget {
  const Admin_ChatPage({super.key});

  @override
  State<Admin_ChatPage> createState() => _Admin_ChatPageState();
}

class _Admin_ChatPageState extends State<Admin_ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendMessage(String receiverID) async {
    if (_controller.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;

    var senderID = (data as List)[0];
    var emergencyMsgID = (data as List)[1];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Chat with ${senderID}'),
        ),
        body: Scaffold(
            body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 10, 8.0, 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildMessagesList(senderID, emergencyMsgID)),
                Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: _buildMessageInput(senderID)),
              ],
            ),
          ),
        )));
  }

  //Build Message List
  Widget _buildMessagesList(String receiverID, emergencyMsgID) {
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading...'));
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document, emergencyMsgID))
              .toList(),
        );
      },
    );
  }

//Build Message Item
  Widget _buildMessageItem(DocumentSnapshot document, emergencyMsgID) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //align user message to the right, receiver to the left
    var alignment = data['senderID'] == _auth.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: alignment == Alignment.centerRight
              ? Colors.blue[100]
              : Colors.grey[300],
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: data['message'].contains("Emergency!")
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        Text(data['senderEmail']),
                      ],
                    ),
                  ),
                  Text(data['message'],
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              )
            : Column(
                children: [
                  Text(
                    data['senderEmail'],
                  ),
                  Text(data['message']),
                ],
              ),
      ),
    );
  }

//Build Message Input
  Widget _buildMessageInput(String receiverID) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter a message',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(receiverID),
          ),
        ],
      ),
    );
  }
}
