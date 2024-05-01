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
    return Scaffold(
      appBar: DefaultAppBar(),
      body: const Center(
        child: Text("Simple Diagnostic Page"),
      )
    );
  }
}