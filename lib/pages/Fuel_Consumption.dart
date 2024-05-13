import 'package:car_management/components/appbar.dart';
import 'package:car_management/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:car_management/components/globals.dart' as globals;

class Fuel_ConsumptionPage extends StatefulWidget {
  const Fuel_ConsumptionPage({super.key});

  @override
  State<Fuel_ConsumptionPage> createState() => _Fuel_ConsumptionPageState();
}

class _Fuel_ConsumptionPageState extends State<Fuel_ConsumptionPage> {
  final _auth = FirebaseAuth.instance;

  //update records in firestore
  void postDetailsToFirestore(Map value) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('fuel');
    ref.doc(user!.uid).update(value as Map<Object, Object?>);
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;

    List<_FuelData> chartData = [
      _FuelData(
          globals.fuelData[(data as Map?)?['dropdownValue']]['Timestamp'][0],
          globals.fuelData[(data as Map?)?['dropdownValue']]
              ['Fuel Pumped'][0].toDouble()),
      _FuelData(
          globals.fuelData[(data as Map?)?['dropdownValue']]['Timestamp'][1],
          globals.fuelData[(data as Map?)?['dropdownValue']]
              ['Fuel Pumped'][2].toDouble()),
      _FuelData(
          globals.fuelData[(data as Map?)?['dropdownValue']]['Timestamp'][2],
          globals.fuelData[(data as Map?)?['dropdownValue']]
              ['Fuel Pumped'][2].toDouble()),
      _FuelData(
          globals.fuelData[(data as Map?)?['dropdownValue']]['Timestamp'][3],
          globals.fuelData[(data as Map?)?['dropdownValue']]
              ['Fuel Pumped'][3].toDouble()),
    ];

    //Controllers for the textfields
    TextEditingController _controller = TextEditingController();
    TextEditingController _controller1 = TextEditingController();
    TextEditingController _controller2 = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    DateTime now = DateTime.now();
    DateTime dateOnly = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Fuel Consumption',
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            const Text(
              "Log your fuel consumption for: ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Text(
              (data as Map?)?['dropdownValue'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(text: 'Fuel Consumption / KM'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<_FuelData, String>>[
                        LineSeries<_FuelData, String>(
                            dataSource: chartData,
                            xValueMapper: (_FuelData fueldata, _) =>
                                fueldata.timeStamp,
                            yValueMapper: (_FuelData fueldata, _) =>
                                fueldata.fuelPumped,
                            name: 'Represents each Fuel Up',
                            // Enable data label
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true))
                      ]),
                )),
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            MaintenanceButton(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 30,
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20.0, left: 20.0),
                                    child: Text(
                                      'Add a Fuel Log Entry',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.blueGrey[800],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 20, 20.0, 0.0),
                                    child: SizedBox(
                                      child: TextField(
                                        controller: _controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Odometer Reading',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 20, 20.0, 0.0),
                                    child: SizedBox(
                                      child: TextField(
                                        controller: _controller1,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Fuel Pumped (Litre)',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 20, 20.0, 0.0),
                                    child: SizedBox(
                                      child: TextField(
                                        controller: _controller2,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          print(_controller2.text);
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Price per Litre (RM)',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          globals.fuelData[(data as Map?)?[
                                                      'dropdownValue']]
                                                  ['Odometer Reading']
                                              .add(_controller.text);

                                          globals.fuelData[(data as Map?)?[
                                                      'dropdownValue']]
                                                  ['Fuel Pumped']
                                              .add(int.parse(_controller1.text));

                                          globals.fuelData[(data as Map?)?[
                                                      'dropdownValue']]
                                                  ['Price per Litre']
                                              .add(_controller2.text);

                                          globals.fuelData[(data as Map?)?[
                                                  'dropdownValue']]['Timestamp']
                                              .add(DateTime.now()
                                                  .toString()
                                                  .split(" ")[0]);

                                          postDetailsToFirestore(
                                              globals.fuelData);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Upload')),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                text: 'Log'),
          ],
        ),
      ),
    );
  }
}

class _FuelData {
  _FuelData(this.timeStamp, this.fuelPumped);

  final String timeStamp;
  final double fuelPumped;
}
