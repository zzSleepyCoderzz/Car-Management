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
  List<String> dropdownItems = [
    globals.carData['Car1']['Car Model'],
    globals.carData['Car2']['Car Model'],
    globals.carData['Car3']['Car Model'],
  ];
  String dropdownValue = globals.carData['Car1']['Car Model'];
  int index = 1;

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
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  width: 120,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF3331c6), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height:
                            0, // Set height to 0 to effectively remove the underline
                      ),
                      style: const TextStyle(color: Color(0xFF3331c6)),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          index = dropdownItems
                                  .indexWhere((item) => item == newValue) +
                              1;
                        });
                      },
                      items: dropdownItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                MaintenanceButton(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/service_history',
                        arguments: {
                          'dropdownValue': dropdownValue,
                          'index': "Car" + index.toString(),
                        },
                      );
                      print('Selected index: $index');
                    },
                    text: 'Service History'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                MaintenanceButton(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/simple_diagnostics',
                        arguments: {
                          'dropdownValue': dropdownValue,
                          'index': "Car" + index.toString(),
                        },
                      );
                    },
                    text: 'Simple Diagnostics'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                MaintenanceButton(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/fuel_consumption',
                        arguments: {
                          'dropdownValue': dropdownValue,
                          'index': "Car" + index.toString(),
                        },
                      );
                    },
                    text: 'Fuel Consumption'),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
