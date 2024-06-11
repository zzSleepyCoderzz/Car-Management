// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:car_management/components/appbar.dart';
import 'package:car_management/components/home_card.dart';
import 'package:car_management/pages/Maintenance.dart';
import 'package:car_management/pages/Profile.dart';
import 'package:car_management/pages/Tracking.dart';
import 'package:car_management/pages/Chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  int currentIndex = 2;
  PageController _pageController = PageController(initialPage: 2);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'Tune Up Garage',),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF3331c6),
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
            icon: Icon(Icons.track_changes),
            label: 'Tracking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Maintenance',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.headset_mic), label: 'Live Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
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
          TrackingPage(),
          MaintenancePage(),
          HomeBody(),
          ChatPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 30),
      child: Center(
        child: Column(
          children: [
            Text(
              'Welcome, ${globals.userData['Name']}!',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            globals.userData['Name'] == 'User'
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Please update your profile to get started!',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 0, 0),
                        fontSize: 14,
                      ),
                    ),
                  )
                : Container(),
            HomeCard(
              carNumber: "Car1",
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            HomeCard(
              carNumber: "Car2",
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            HomeCard(
              carNumber: "Car3",
            ),
          ],
        ),
      ),
    ));
  }
}
