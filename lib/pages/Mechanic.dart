import 'package:car_management/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MechanicPage extends StatefulWidget {
  const MechanicPage({super.key});

  @override
  State<MechanicPage> createState() => _MechanicPageState();
}

class _MechanicPageState extends State<MechanicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: const Center(
        child: Text("Mechanic Page"),
      )
    );
  }
}