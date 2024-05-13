import 'package:car_management/components/appbar.dart';
import 'package:car_management/components/button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Fuel_ConsumptionPage extends StatefulWidget {
  const Fuel_ConsumptionPage({super.key});

  @override
  State<Fuel_ConsumptionPage> createState() => _Fuel_ConsumptionPageState();
}

class _Fuel_ConsumptionPageState extends State<Fuel_ConsumptionPage> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;

    List<_FuelData> chartData = [
      _FuelData('Jan', 35),
      _FuelData('Feb', 28),
      _FuelData('Mar', 34),
      _FuelData('Apr', 32),
      _FuelData('May', 40)
    ];

    TextEditingController _controller = TextEditingController();
    final _formKey = GlobalKey<FormState>();

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
                      title: ChartTitle(text: 'Fuel Consumption (Litre)'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<_FuelData, String>>[
                        LineSeries<_FuelData, String>(
                            dataSource: chartData,
                            xValueMapper: (_FuelData sales, _) => sales.year,
                            yValueMapper: (_FuelData sales, _) => sales.sales,
                            name: 'Fuel Consumption',
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
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                                    child: Text(
                                      'Upload the amount of fuel you have pumped today:',
                                       textAlign: TextAlign.center, 
                                      style: TextStyle(

                                        fontSize: 20.0,
                                        color: Colors.blueGrey[800],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "Fuel Pumped (Litres)",
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      validator: (val) => val?.length == 0
                                          ? "Please enter a name"
                                          : null,
                                      onChanged: (val) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                        onPressed: () {},
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
  _FuelData(this.year, this.sales);

  final String year;
  final double sales;
}
