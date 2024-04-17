import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //appBar: AppBar(
      //  backgroundColor: Colors.grey[50],
      //  leading: IconButton(
      //    icon: Icon(Icons.arrow_back_rounded),
      //    color: Colors.blueGrey[800],
      //    onPressed: () {
      //      GoRouter.of(context).go('/home');
      //   },
      // ),
      //  elevation: 0,
      //),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Maintenance Page'),
          ],
        ),
      ),
    );
  }
}
