import 'package:flutter/material.dart';

class TuningPage extends StatefulWidget {
  const TuningPage({super.key});

  @override
  State<TuningPage> createState() => _TuningPageState();
}

class _TuningPageState extends State<TuningPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Tuning Page'),
        ],
      ),
    ));
  }
}