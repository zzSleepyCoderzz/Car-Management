import 'package:car_management/components/appbar.dart';
import 'package:flutter/material.dart';

class Simple_DiagnosticPage extends StatefulWidget {
  const Simple_DiagnosticPage({super.key});

  @override
  State<Simple_DiagnosticPage> createState() => _Simple_DiagnosticPageState();
}

class _Simple_DiagnosticPageState extends State<Simple_DiagnosticPage> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: DefaultAppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            Text(
              "Simple Diagnostics for Car Model: ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Text(
              (data as Map?)?['dropdownValue'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
