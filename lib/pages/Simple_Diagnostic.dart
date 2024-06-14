import 'package:car_management/components/button.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'dart:math';

class Simple_DiagnosticPage extends StatefulWidget {
  const Simple_DiagnosticPage({super.key});

  @override
  State<Simple_DiagnosticPage> createState() => _Simple_DiagnosticPageState();
}

class _Simple_DiagnosticPageState extends State<Simple_DiagnosticPage> {
  List<List<dynamic>>? _data;
  List<dynamic>? _columnSData;
  String? _analysisResult;
  String? _dataLoadStatus;

  Future<void> pickAndReadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final String extension = file.extension ?? '';

      if (extension == 'csv') {
        final String csvString = await File(file.path!).readAsString();
        final List<List<dynamic>> csvTable =
            const CsvToListConverter().convert(csvString);
        setState(() {
          _dataLoadStatus = "Data loaded successfully.";
        });
        analyzeData(csvTable);
      } else if (extension == 'xlsx') {
        final List<int> bytes = await File(file.path!).readAsBytes();
        final Excel excel = Excel.decodeBytes(bytes);
        final List<List<dynamic>> excelTable = [];

        for (final String table in excel.tables.keys) {
          for (final List<Data?> row in excel.tables[table]!.rows) {
            final List<dynamic> rowData =
                row.map((cell) => cell?.value).toList();
            excelTable.add(rowData);
          }
        }
        setState(() {
          _data = excelTable;
        });
        analyzeData(excelTable);
      }
    }
  }

  void analyzeData(List<List<dynamic>> table) async {
    if (table.isNotEmpty) {
      final List<dynamic> header = table[0];
      int columnIndex = header.indexOf('S');

      if (columnIndex == -1 && header.length >= 19) {
        columnIndex = 18;
      }

      if (columnIndex != -1) {
        List<dynamic> columnSData = [];
        for (int i = 1; i < table.length; i++) {
          if (table[i].length > columnIndex) {
            columnSData.add(table[i][columnIndex]);
          }
        }
        setState(() {
          _columnSData = columnSData;
        });

        if (columnSData.isNotEmpty) {
          double firstValue = columnSData.first;
          double lastValue = columnSData.last;
          double rateOfChange = (lastValue - firstValue) / 30;
          int delaySeconds = Random().nextInt(3) + 3;

          await Future.delayed(Duration(seconds: delaySeconds), () {
            if (rateOfChange > 0.001515) {
              setState(() {
                _analysisResult = "Potential oil leak detected.";
              });
            } else {
              setState(() {
                _analysisResult = "No significant oil leak detected.";
              });
            }
          });
        }
      } else {
        setState(() {
          _analysisResult = "Data does not contain the required column.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Diagnostics"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Connect your phone to the car's OBD-II port,",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            const Icon(
              Icons.usb_sharp,
              size: 150,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "then press the button below to begin the diagnostic process.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            MaintenanceButton(
              text: "Start Diagnostic",
              onTap: () async {
                pickAndReadFile();
                await Future.delayed(
                    Duration(seconds: 2)); // Introduce a delay of 2 seconds
                if (_dataLoadStatus == "Data loaded successfully.") {
                  setState(() {
                    _analysisResult = "Checking for oil leak issue...";
                  });
                }
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            _data != null
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_data![index].join(', ')),
                        );
                      },
                    ),
                  )
                : Text(_dataLoadStatus ?? 'No data uploaded yet'),
            _analysisResult != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _analysisResult!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
