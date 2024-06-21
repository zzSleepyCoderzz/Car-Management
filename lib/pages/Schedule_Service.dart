import 'package:car_management/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:car_management/components/globals.dart' as globals;

class Schedule_ServicePage extends StatefulWidget {
  const Schedule_ServicePage({super.key});

  @override
  State<Schedule_ServicePage> createState() => _Schedule_ServicePageState();
}

class _Schedule_ServicePageState extends State<Schedule_ServicePage> {
  final _auth = FirebaseAuth.instance;

  //update records in firestore
  void postDetailsToFirestore(Map value) {
    var user = _auth.currentUser;
    CollectionReference ref =
        FirebaseFirestore.instance.collection('scheduled_service');
    ref.doc(user!.uid).update(value as Map<Object, Object?>);
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    var datePicked;

    //Text Controller
    final TextEditingController controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    //Timeslots
    List<String> timeSlots = [
      '9:00 AM - 10:00 AM',
      '10:00 AM - 11:00 AM',
      '11:00 AM - 12:00 PM',
      '1:00 PM - 2:00 PM',
      '2:00 PM - 3:00 PM'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Service"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            const Text(
              "Upcoming Service for Car Model: ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Text(
              (data as Map?)?['dropdownValue'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      "NEXT SERVICE ON: ${globals.scheduledService[(data)?['index']][globals.scheduledService[(data)?['index']].length - 1]['Date']}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "TIME: ${globals.scheduledService[(data)?['index']][globals.scheduledService[(data)?['index']].length - 1]['Timeslot']}",
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "Remarks to Mechanic: \n ${globals.scheduledService[(data)?['index']][globals.scheduledService[(data)?['index']].length - 1]['Remarks']}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.2),
            MaintenanceButton(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      //Stateful builder allows the bottomModalSheet to be updated
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) =>
                            SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 30,
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Form(
                                key: formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GeneralButton(
                                          
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  //Show Date Picker
                                                  return AlertDialog(
                                                    title: const Text("Select Date"),
                                                    content: SizedBox(
                                                      height: 300,
                                                      width: 200,
                                                      child: SfDateRangePicker(
                                                        view:
                                                            DateRangePickerView
                                                                .month,
                                                        onSelectionChanged:
                                                            (dateRangePickerSelectionChangedArgs) =>
                                                                {
                                                          datePicked =
                                                              dateRangePickerSelectionChangedArgs
                                                                  .value,
                                                          datePicked =
                                                              datePicked
                                                                  .toString()
                                                                  .split(
                                                                      ' ')[0],
                                                          setState(() {
                                                            globals
                                                                .scheduledService[(data)?[
                                                                'index']][globals
                                                                    .scheduledService[(data)?[
                                                                        'index']]
                                                                    .length -
                                                                1]['Date'] = datePicked;
                                                          })
                                                        },
                                                        monthViewSettings:
                                                            const DateRangePickerMonthViewSettings(
                                                                firstDayOfWeek:
                                                                    1),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text("Confirm"),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          text: "Set Date: ${globals.scheduledService[(data)?['index']][globals.scheduledService[(data)?['index']].length - 1]['Date']}",
                                          color: "0xFF000000",),

                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),

                                      //Show Select Time Slots
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: DropdownButton<String>(
                                          underline:
                                              Container(), //Remove the underline
                                          hint: const Text("Select a Time Slot"),
                                          value: globals.scheduledService[(data)?['index']]
                                                          [globals.scheduledService[(data)?['index']].length - 1]
                                                      ['Timeslot'] ==
                                                  ''
                                              ? null
                                              : globals.scheduledService[(data)?['index']][globals
                                                      .scheduledService[(data)?['index']]
                                                      .length -
                                                  1]['Timeslot'],
                                          onChanged: (value) {
                                            setState(() {
                                              globals.scheduledService[(data)?['index']][globals
                                                      .scheduledService[(data)?['index']]
                                                      .length -
                                                  1]['Timeslot'] = value!;
                                            });
                                          },
                                          items: timeSlots
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 20, 20.0, 0.0),
                                        child: SizedBox(
                                          child: TextField(
                                            controller: controller,
                                            onChanged: (value) => {
                                              globals.scheduledService[(data)?['index']][globals
                                                      .scheduledService[(data)?['index']]
                                                      .length -
                                                  1]['Remarks'] = value
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Remarks',
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      GeneralButton(
                                          onTap: () {
                                            //Setting Car Model based on previous page
                                            globals.scheduledService[
                                                    (data)?['index']][
                                                globals
                                                        .scheduledService[(data)?['index']]
                                                        .length -
                                                    1]['Car Model'] = (data)?['dropdownValue'];

                                            postDetailsToFirestore(
                                                globals.scheduledService);
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text("Service Scheduled"),
                                                  content: const Text(
                                                      "Service has been scheduled successfully"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("OK"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          text: "Submit",
                                                          color: "0xFF3331c6",)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                text: 'Schedule Maintenance'),
          ],
        ),
      ),
    );
  }
}
