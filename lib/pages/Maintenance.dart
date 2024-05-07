import 'package:car_management/components/button.dart';
import 'package:flutter/material.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 50),
      child: Center(
        child: Column(
          children: [
            const Text(
              'Keep your car in tip-top shape!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                MaintenanceButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/service_history');
                    },
                    text: 'Service History'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                MaintenanceButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/simple_diagnostics');
                    },
                    text: 'Simple Diagnostics'),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
