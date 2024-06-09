import 'package:car_management/components/appbar.dart';
import 'package:car_management/components/service_history_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:car_management/components/globals.dart' as globals;

class Service_HistoryPage extends StatefulWidget {
  const Service_HistoryPage({super.key});

  @override
  State<Service_HistoryPage> createState() => _Service_HistoryPageState();
}

class _Service_HistoryPageState extends State<Service_HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Service History"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/schedule_service',
                    arguments: data);
              }, icon: const Icon(Icons.calendar_month_rounded)),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            const Text(
              "Service History for Car Model: ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Text(
              (data as Map?)?['dropdownValue'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            Service_History_Container(
                title: "Mileage",
                value:
                    "Kilometers: ${globals.serviceData[(data as Map?)?['index']][0]['Mileage']}"),
            Service_History_Container(
                title: "Engine Oil",
                value:
                    "Last Changed: ${globals.serviceData[(data as Map?)?['index']][1]['Engine Oil']}"),
            Service_History_Container(
                title: "Break Pads",
                value:
                    "Last Changed: ${globals.serviceData[(data as Map?)?['index']][2]['Break Pads']}"),
            Service_History_Container(
                title: "Air Filter",
                value:
                    "Last Changed: ${globals.serviceData[(data as Map?)?['index']][3]['Air Filter']}"),
            Service_History_Container(
                title: "Alignment",
                value:
                    "Last Serviced: ${globals.serviceData[(data as Map?)?['index']][4]['Alignment']}"),
          ],
        ),
      ),
    );
  }
}
