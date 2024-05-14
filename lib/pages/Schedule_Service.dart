import 'package:car_management/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Schedule_ServicePage extends StatefulWidget {
  const Schedule_ServicePage({super.key});

  @override
  State<Schedule_ServicePage> createState() => _Schedule_ServicePageState();
}

class _Schedule_ServicePageState extends State<Schedule_ServicePage> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;

    var datePicked;

    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Schedule Service',
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            const Text(
              "Scheduling Service for Car Model: ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Text(
              (data as Map?)?['dropdownValue'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                onSelectionChanged: (dateRangePickerSelectionChangedArgs) => {
                  datePicked = dateRangePickerSelectionChangedArgs.value,
                  datePicked = datePicked.toString().split(' ')[0],
                  print(datePicked)
                },
                monthViewSettings:
                    DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
