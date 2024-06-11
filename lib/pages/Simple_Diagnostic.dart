import 'package:car_management/components/button.dart';
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
      appBar: AppBar(
        title: Text("Simple Diagnostics"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            const Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Connect your phone to the car's OBD-II port,",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            const Icon(
              Icons.usb_sharp,
              size: 150,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            const Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "then press the button below to begin the diagnostic process.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            MaintenanceButton(
              text: "Start Diagnostic",
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
