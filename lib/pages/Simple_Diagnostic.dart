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
            Container(
              child: Text("Simple Diagnostics for Car Model: ${data}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}