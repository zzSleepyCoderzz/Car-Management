import 'package:car_management/components/appbar.dart';
import 'package:car_management/pages/Admin/Emergency.dart';
import 'package:car_management/pages/Admin/Set_Mechanic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Admin Bottom Navigation Bar
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Admin Page',
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF3331c6),
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
            icon: Icon(Icons.warning_rounded),
            label: 'Emergency',
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
          EmergencyPage(),
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
  @override
  void initState() {
    super.initState();
    getEmergencyList();
  }

  var emergencyList = [];

  //get all pending emergency requests
  Future<void> getEmergencyList() async {
    final emergency = await FirebaseFirestore.instance
        .collection('emergency')
        .where('status', isEqualTo: 'Pending')
        .get();

    if (emergency.docs.isNotEmpty) {
      for (var i in emergency.docs) {
        emergencyList.add(i['userID']);
        emergencyList.add(i.id);
      }
    } else {
      emergencyList = ['', ''];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold();
        }

        final users = snapshot.data?.docs;

        return ListView.builder(
          itemCount: users?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, '/admin_chat',
                        arguments: [users?[index].id, emergencyList[1]]);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: emergencyList.contains(users?.elementAt(index).id)
                        ? Colors.red
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors
                          .black, // Change this color to change the border color
                      width: 2,
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
        );
      },
    );
  }
}
