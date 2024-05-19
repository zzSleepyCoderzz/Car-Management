import 'package:flutter/material.dart';

class Maintenance_DetailsPage extends StatefulWidget {
  const Maintenance_DetailsPage({super.key});

  @override
  State<Maintenance_DetailsPage> createState() =>
      _Maintenance_DetailsPageState();
}

class _Maintenance_DetailsPageState extends State<Maintenance_DetailsPage> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as MapEntry;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Details'),
      ),
      body: Column(
        children: [
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    "DATE: ${data.value[0]['Date']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "TIME:  ${data.value[0]['Timeslot']}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Remarks to Mechanic: \n  ${data.value[0]['Remarks']}",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
