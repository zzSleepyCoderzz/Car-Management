import 'package:car_management/components/appbar.dart';
import 'package:car_management/components/service_history_container.dart';
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
    final data = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: DefaultAppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            Container(
              child: Text("Service History for ${data}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            Service_History_Container(title: "Mileage", value: "Kilometers: 10000"),
            Service_History_Container(title: "Engine Oil", value: "Last Changed: 2021-10-01"),
            Service_History_Container(title: "Break Pads", value: "Last Changed: 2021-10-01"),
            Service_History_Container(title: "Air Filter", value: "Last Changed: 2021-10-01"),
            Service_History_Container(title: "Alignment", value: "Last Serviced: 2024-10-10"),
          ],
        ),
      ),
    );
  }
}
