import 'package:car_management/components/button.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/globals.dart' as globals;

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  //Dropdown to choose car
  String dropdownValue = globals.carData['Car1']['Car Model'];

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
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                //Dropdown to choose car
                Text('Choose a car:'),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    globals.carData['Car1']['Car Model'],
                    globals.carData['Car2']['Car Model'],
                    globals.carData['Car3']['Car Model']
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                MaintenanceButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/service_history',
                          arguments: dropdownValue);
                    },
                    text: 'Service History'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                MaintenanceButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/simple_diagnostics',
                          arguments: dropdownValue);
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
