import 'package:car_management/components/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('emergency')
            .doc(data as String)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(); // or some other widget while waiting
          }

          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text('Chat with ${data as String}'),
              ),
              body: Scaffold(
                  body: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 10, 8.0, 20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: _buildMessagesList(
                              data as String, snapshot.data!.data())),
                      Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: _buildMessageInput(data)),
                    ],
                  ),
                ),
              )));
        });
  }

  //Build Message List
  Widget _buildMessagesList(String receiverID, userEmergencyRecords) {
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
              .map((document) =>
                  _buildMessageItem(document, userEmergencyRecords))
              .toList(),
        );
      },
    );
  }

//Build Message Item
  Widget _buildMessageItem(DocumentSnapshot document, userEmergencyRecords) {
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
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            try {
                              var i = userEmergencyRecords['emergency'];
                              i[i.length - 1]['status'] = "Solved";
                              i[i.length - 1]['timeSolved'] = DateTime.now();
                              FirebaseFirestore.instance
                                  .collection('emergency')
                                  .doc(data['senderID'])
                                  .update({'emergency': i}).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    margin: EdgeInsets.all(20),
                                    behavior: SnackBarBehavior.floating,
                                    content:
                                        Text('Emergency marked as solved!'),
                                  ),
                                );
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                "Solved",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(Icons.check, color: Colors.green),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(data['message'],
                      style: TextStyle(
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
