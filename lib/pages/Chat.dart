import 'dart:async';

import 'package:car_management/components/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _isLoading = true;
  var emergencyList = [];

  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AdminID = "1B8yq8Q1NiXhbnLLqgXSF20V2EY2";

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await _chatService.sendMessage(
          // Admin ID hardcoded
          AdminID,
          _controller.text);
      _controller.clear();
    }
  }

  void emergency() async {
    await _chatService.sendMessage(
        // Admin ID hardcoded
        AdminID,
        "Emergency! Requesting immediate assistance.");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('emergency')
            .where('status', isEqualTo: 'Pending')
            .get(),
        builder: (context, snapshot) {
          return Scaffold(
              body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildMessagesList()),
                Padding(
                    padding: EdgeInsets.only(
                        left: 20.0,
                        bottom: MediaQuery.of(context).size.width * 0.03),
                    child: _buildMessageInput()),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.1),
                  child: ElevatedButton(
                    onPressed: () {
                      for (var document in snapshot.data!.docs) {
                        emergencyList.add(document.data()['email']);
                      }
                      var numOfEmergencyRequests = 0;
                      for (var doc in emergencyList) {
                        doc == _auth.currentUser!.email
                            ? numOfEmergencyRequests++
                            : null;
                      }

                      //check if the amount of emergency request is less than 3
                      if (numOfEmergencyRequests < 1) {
                        emergency();
                        FirebaseFirestore.instance.collection('emergency').add({
                          'email': _auth.currentUser!.email,
                          'status': "Pending"
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "You have reached the maximum number of emergency requests."),
                          ),
                        );
                      }

                      //clear the emergencyList
                      emergencyList.clear();
                      numOfEmergencyRequests = 0;
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "EMERGENCY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
        });
  }

//Build Message List
  Widget _buildMessagesList() {
    return StreamBuilder(
      stream: _chatService.getMessages(AdminID, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        //delay the loading indicator
        Timer(const Duration(seconds: 2), () {
          if (this.mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
        

        return _isLoading
            ? const Center(child: CircularProgressIndicator(
              color: Color(0xFF3331c6),
            ))
            : ListView(
                children: snapshot.data!.docs
                    .map((document) => _buildMessageItem(document))
                    .toList(),
              );
      },
    );
  }

//Build Message Item
  Widget _buildMessageItem(DocumentSnapshot document) {
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
          child: Column(
            children: [
              Text(
                data['senderEmail'],
              ),
              Text(data['message'],
                  style: data['message'].contains("Emergency!")
                      ? TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)
                      : TextStyle(
                          color: Colors.black,
                        )),
            ],
          )),
    );
  }

//Build Message Input
  Widget _buildMessageInput() {
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
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
