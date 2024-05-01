import 'package:car_management/components/appbar.dart';
import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text("Service History Page"),
      )
    );
  }
}