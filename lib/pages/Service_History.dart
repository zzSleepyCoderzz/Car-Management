import 'package:car_management/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Service_HistoryPage extends StatefulWidget {
  const Service_HistoryPage({super.key});

  @override
  State<Service_HistoryPage> createState() => _Service_HistoryPageState();
}

class _Service_HistoryPageState extends State<Service_HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text("Service History"),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            Container(
              child: Text("Mileage"),
            ),
            Container(
              child: Text("Oil Change"),
            ),
            Container(
              child: Text("Break Pads"),
            ),
            Container(
              child: Text("Air Filter"),
            ),
            Container(
              child: Text("Alignment"),
            ),
          ],
        ),
      ),
    );
  }
}