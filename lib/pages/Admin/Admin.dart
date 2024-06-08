import 'package:car_management/components/appbar.dart';
import 'package:car_management/components/chat_service.dart';
import 'package:car_management/pages/Admin/Set_Mechanic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Admin Bottom Navigation Bar
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentIndex = 1;
  PageController _pageController = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Admin Page',
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple[800],
        unselectedItemColor: Colors.blueGrey[800],
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            _pageController.jumpToPage(value);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Assign',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headset_mic),
            label: 'Chat',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        children: const [
          Set_MechanicPage(),
          AdminBody(),
        ],
      ),
    );
  }
}

//Admin Body
class AdminBody extends StatefulWidget {
  const AdminBody({super.key});

  @override
  State<AdminBody> createState() => _AdminBodyState();
}

class _AdminBodyState extends State<AdminBody> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  void _sendMessage(String receiverID) async {
    if (_controller.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('users').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final users = snapshot.data?.docs;
            return Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                itemCount: users?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/admin_chat',
                          arguments: users?[index].id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors
                                .black, // Change this color to change the border color
                            width:
                                2, // Change this value to change the border width
                          ),
                        ),
                        child: ListTile(
                          title: Text(users?[index]['Name']),
                          subtitle: Text(users?[index]['email']),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
