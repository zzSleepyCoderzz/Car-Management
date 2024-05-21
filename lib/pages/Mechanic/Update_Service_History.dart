import 'package:car_management/components/appbar.dart';
import 'package:car_management/components/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/globals.dart' as globals;

class Update_Service_HistoryPage extends StatefulWidget {
  const Update_Service_HistoryPage({super.key});

  @override
  State<Update_Service_HistoryPage> createState() =>
      _Update_Service_HistoryPageState();
}

class _Update_Service_HistoryPageState
    extends State<Update_Service_HistoryPage> {
  

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    print(data['userID']);
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Update Service History',
      ),
      body: Center(
        child: Column(
          children: [
            Update_Maintenance_List_Tile(
              tileName: "Mileage", value: data['Car Number'], userID: data['userID'],
            ),
            Update_Maintenance_List_Tile(
              tileName: "Engine Oil", value: data['Car Number'], userID: data['userID'],
            ),
            Update_Maintenance_List_Tile(
              tileName: "Break Pads", value: data['Car Number'], userID: data['userID'],
            ),
            Update_Maintenance_List_Tile(
              tileName: "Air Filter", value: data['Car Number'], userID: data['userID'],
            ),
            Update_Maintenance_List_Tile(
              tileName: "Alignment", value: data['Car Number'], userID: data['userID'],
            ),
            Update_Maintenance_List_Tile(
              tileName: "Battery", value: data['Car Number'], userID: data['userID'],
            ),
            Update_Maintenance_List_Tile(
              tileName: "Coolant", value: data['Car Number'], userID: data['userID'],
            ),
            Update_Maintenance_List_Tile(
              tileName: "Spark Plugs", value: data['Car Number'], userID: data['userID'],
            ),
            Update_Maintenance_List_Tile(
              tileName: "Tyres", value: data['Car Number'], userID: data['userID'],
            ),
            Update_Maintenance_List_Tile(
              tileName: "Transmission Fluid", value: data['Car Number'], userID: data['userID'],
            ),
          ],
        ),
      ),
    );
  }
}
