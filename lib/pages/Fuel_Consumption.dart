import 'package:car_management/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:car_management/components/globals.dart' as globals;
import 'package:car_management/components/auth.dart';
import 'package:car_management/components/gas_price_widget.dart';

class Fuel_ConsumptionPage extends StatefulWidget {
  const Fuel_ConsumptionPage({super.key});

  @override
  State<Fuel_ConsumptionPage> createState() => _Fuel_ConsumptionPageState();
}

class _Fuel_ConsumptionPageState extends State<Fuel_ConsumptionPage> {
  final _auth = FirebaseAuth.instance;

  //update records in firestore
  void postDetailsToFirestore(Map value) {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('fuel');
    ref.doc(user!.uid).update(value as Map<Object, Object?>);
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;

    List<_FuelData> chartData = [];

    while (chartData.length <
        globals.fuelData[(data as Map?)?['index']]['Odometer Reading'].length) {
      chartData.add(_FuelData(
          globals.fuelData[(data)?['index']]['Timestamp'][chartData.length],
          globals.fuelData[(data)?['index']]['Fuel Pumped'][chartData.length]
              .toDouble()));
    }

    //Controllers for the textfields
    TextEditingController _controller = TextEditingController();
    TextEditingController _controller1 = TextEditingController();
    TextEditingController _controller2 = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fuel Consumption"),
        actions: [
          IconButton(
            icon: const Icon(Icons.oil_barrel),
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    AlertDialog(
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Column(
                      children: [
                        Text(
                          'Current Gas Prices',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.bold),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GasPriceWidget(), // Assuming this is a custom widget for displaying gas prices
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Nice!'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                    ),
                  ],
                ),
                transitionBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1), // Start from below the screen
                      end: Offset.zero, // End at its final position
                    ).animate(animation),
                    child: child,
                  );
                },
                transitionDuration: const Duration(
                    milliseconds: 300), // Adjust the duration as needed
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Column(
              children: [
                const Text(
                  "Log your fuel consumption for: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                Text(
                  (data)?['dropdownValue'],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.03),
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
                          primaryXAxis: const CategoryAxis(),
                          // Chart title
                          title:
                              const ChartTitle(text: 'Fuel Consumption / KM'),
                          // Enable legend
                          legend: const Legend(isVisible: true),
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
                                    const DataLabelSettings(isVisible: true))
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
                            child: SizedBox(
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 20, 20.0, 0.0),
                                        child: SizedBox(
                                          child: TextField(
                                            controller: _controller,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Odometer Reading',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 20, 20.0, 0.0),
                                        child: SizedBox(
                                          child: TextField(
                                            controller: _controller1,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Fuel Pumped (Litre)',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 20, 20.0, 0.0),
                                        child: SizedBox(
                                          child: TextField(
                                            controller: _controller2,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              //Do something with the user input.
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Price per Litre (RM)',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: GeneralButton(
                                            onTap: () async {
                                              globals.fuelData[(data)?['index']]
                                                      ['Odometer Reading']
                                                  .add(_controller.text);

                                              globals.fuelData[(data)?['index']]
                                                      ['Fuel Pumped']
                                                  .add(int.parse(
                                                      _controller1.text));

                                              globals.fuelData[(data)?['index']]
                                                      ['Price per Litre']
                                                  .add(_controller2.text);

                                              globals.fuelData[(data)?['index']]
                                                      ['Timestamp']
                                                  .add(DateTime.now()
                                                      .toString()
                                                      .split(" ")[0]);

                                              postDetailsToFirestore(
                                                  globals.fuelData);

                                              //Run Auth to get the updated details
                                              await const Auth().userDetails();

                                              //Pop if there the current page is mounted
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                            },
                                            text: "Upload",
                                            color: "0xFF3331c6",),
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
