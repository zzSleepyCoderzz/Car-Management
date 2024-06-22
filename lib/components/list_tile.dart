import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/button.dart';
import 'package:car_management/components/globals.dart' as globals;

class Profile_List_Tile extends StatefulWidget {
  const Profile_List_Tile({super.key, required this.tileName});

  final String tileName;

  @override
  State<Profile_List_Tile> createState() => _Profile_List_TileState();
}

class _Profile_List_TileState extends State<Profile_List_Tile> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var _currentValue;

  //update records in firestore
  void postDetailsToFirestore(String key, String value) {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).update({key: value});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
          widget.tileName == "Name"
              ? Icons.person
              : widget.tileName == "Age"
                  ? Icons.info_outline
                  : Icons.male,
          color: Colors.blueGrey[800]),
      title: Text(
        widget.tileName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(globals.userData[widget.tileName]),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
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
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Update ${widget.tileName}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                            child: TextFormField(
                              keyboardType: widget.tileName == "Age"
                                  ? TextInputType.number
                                  : TextInputType.text,
                              initialValue: globals.userData[widget.tileName],
                              decoration: InputDecoration(
                                hintText: widget.tileName,
                                hintStyle: const TextStyle(color: Colors.black),
                              ),
                              validator: (val) => val?.length == 0
                                  ? "Please enter a name"
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  _currentValue = val;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: GeneralButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    postDetailsToFirestore(
                                        widget.tileName, _currentValue);
                                    Navigator.pop(context);
                                  }
                                  setState(() {
                                    globals.userData[widget.tileName] =
                                        _currentValue;
                                  });
                                },
                                text: "Update",
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
      ),
    );
  }
}

class Add_Car_ListTile extends StatefulWidget {
  const Add_Car_ListTile(
      {super.key, required this.tileName, required this.carModel});

  final String tileName;
  final String carModel;

  @override
  State<Add_Car_ListTile> createState() => _Add_Car_ListTileState();
}

class _Add_Car_ListTileState extends State<Add_Car_ListTile> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var _currentValue;

  //update records in firestore
  void postDetailsToFirestore(String key, String value) {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).update({key: value});
  }

  //update records in firestore
  void postCarDetailsToFirestore(data) {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('cars');
    ref.doc(user!.uid).update({data: globals.carData[data]});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
          widget.tileName == "Car Model" ? Icons.car_repair : Icons.numbers,
          color: Colors.blueGrey[800]),
      title: Text(
        widget.tileName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: widget.tileName == "Car Model"
          ? Text(globals.carData[widget.carModel]['Car Model'])
          : Text(globals.carData[widget.carModel]['Number Plate']),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
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
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Update ${widget.tileName}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                            child: TextFormField(
                              initialValue: globals.carData[widget.tileName],
                              decoration: InputDecoration(
                                hintText: widget.tileName,
                                hintStyle: const TextStyle(color: Colors.black),
                              ),
                              // ignore: prefer_is_empty
                              validator: (val) => val?.length == 0
                                  ? "Please enter a name"
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  _currentValue = val;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: GeneralButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {}
                                  setState(() {
                                    globals.carData[widget.carModel]
                                        [widget.tileName] = _currentValue;
                                  });
                                  postCarDetailsToFirestore(widget.carModel);
                                  Navigator.pop(context);
                                },
                               text: "Update",
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
      ),
    );
  }
}

class Update_Maintenance_List_Tile extends StatefulWidget {
  const Update_Maintenance_List_Tile(
      {super.key,
      required this.tileName,
      required this.value,
      required this.userID});

  final String tileName;
  final String value;
  final String userID;

  @override
  State<Update_Maintenance_List_Tile> createState() =>
      _Update_Maintenance_List_TileState();
}

class _Update_Maintenance_List_TileState
    extends State<Update_Maintenance_List_Tile> {
  //update records in firestore
  void updateServiceHistory(var serviceHistory, var userID) {
    CollectionReference ref = FirebaseFirestore.instance.collection('service');
    ref.doc(userID).update(serviceHistory);
  }

  final _formKey = GlobalKey<FormState>();
  String? _currentValue;

  @override
  Widget build(BuildContext context) {
    var initialValue = widget.tileName == "Mileage"
        ? 0
        : widget.tileName == "Engine Oil"
            ? 1
            : widget.tileName == "Break Pads"
                ? 2
                : widget.tileName == "Air Filter"
                    ? 3
                    : widget.tileName == "Alignment"
                        ? 4
                        : widget.tileName == "Battery"
                            ? 5
                            : widget.tileName == "Coolant"
                                ? 6
                                : widget.tileName == "Spark Plugs"
                                    ? 7
                                    : widget.tileName == "Tyres"
                                        ? 8
                                        : widget.tileName ==
                                                "Transmission Fluid"
                                            ? 9
                                            : "";

    return ListTile(
      leading: Icon(Icons.car_repair, color: Colors.blueGrey[800]),
      title: Text(
        widget.tileName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
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
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.tileName == "Mileage"
                                ? "Update: ${widget.tileName} (km)"
                                : "Last Changed: ${widget.tileName}",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                            child: TextFormField(
                              initialValue: globals.serviceHistory[widget.value]
                                      [initialValue][widget.tileName]
                                  .toString(),
                              decoration: InputDecoration(
                                hintText: widget.tileName,
                                hintStyle: const TextStyle(color: Colors.black),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _currentValue = val;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: GeneralButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {}
                                  setState(() {
                                    globals.serviceHistory[widget.value]
                                            [initialValue][widget.tileName] =
                                        _currentValue;
                                    updateServiceHistory(
                                        globals.serviceHistory, widget.userID);
                                  });

                                  Navigator.pop(context);
                                },
                               text: "Update",
                               color: "0xFF3331c6"),
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
      ),
    );
  }
}
