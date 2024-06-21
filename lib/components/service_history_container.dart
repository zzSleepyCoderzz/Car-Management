import 'package:flutter/material.dart';

class Service_History_Container extends StatefulWidget {
  const Service_History_Container(
      {super.key, required this.title, required this.value});

  final String title;
  final value;

  @override
  State<Service_History_Container> createState() =>
      _Service_History_ContainerState();
}

class _Service_History_ContainerState extends State<Service_History_Container> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title, style: const TextStyle(fontSize: 16)),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 0, 0,
                    0), // Change this color to your desired border color
                width: 3, // Change this width to your desired border width
              ),
              borderRadius: BorderRadius.circular(
                  10), // Change this radius to your desired radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.value.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.width * 0.05),
      ],
    );
  }
}
