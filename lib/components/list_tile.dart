import 'package:car_management/pages/Add_Car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/globals.dart' as globals;
import 'package:flutter/services.dart';

class Profile_List_Tile extends StatefulWidget {
  const Profile_List_Tile({super.key, required this.tileName});

  final String tileName;

  @override
  State<Profile_List_Tile> createState() => _Profile_List_TileState();
}

class _Profile_List_TileState extends State<Profile_List_Tile> {
  @override
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var _currentValue;

  //update records in firestore
  void postDetailsToFirestore(String key, String value) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).update({key: value});
  }

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
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(globals.userData[widget.tileName]),
      trailing: IconButton(
        icon: Icon(Icons.edit),
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
                child: Container(
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
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                            child: TextFormField(
                              keyboardType: widget.tileName == "Age"
                                  ? TextInputType.number
                                  : TextInputType.text,
                              initialValue: globals.userData[widget.tileName],
                              decoration: InputDecoration(
                                hintText: widget.tileName,
                                hintStyle: TextStyle(color: Colors.black),
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
                            padding: EdgeInsets.only(top: 20.0),
                            child: ElevatedButton(
                                onPressed: () {
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
                                child: const Text('Update')),
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
  @override
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var _currentValue;

  //update records in firestore
  void postDetailsToFirestore(String key, String value) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).update({key: value});
  }

  //update records in firestore
  void postCarDetailsToFirestore(data) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('cars');
    ref.doc(user!.uid).update({data: globals.carData[data]});
  }

  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
          widget.tileName == "Car Model" ? Icons.car_repair : Icons.numbers,
          color: Colors.blueGrey[800]),
      title: Text(
        widget.tileName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: widget.tileName == "Car Model"
          ? Text(globals.carData[widget.carModel]['Car Model'])
          : Text(globals.carData[widget.carModel]['Number Plate']),
      trailing: IconButton(
        icon: Icon(Icons.edit),
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
                child: Container(
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
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                            child: TextFormField(
                              initialValue: globals.carData[widget.tileName],
                              decoration: InputDecoration(
                                hintText: widget.tileName,
                                hintStyle: TextStyle(color: Colors.black),
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
                            padding: EdgeInsets.only(top: 20.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {}
                                  setState(() {
                                    globals.carData[widget.carModel]
                                        [widget.tileName] = _currentValue;
                                  });
                                  postCarDetailsToFirestore(widget.carModel);
                                  Navigator.pop(context);
                                },
                                child: const Text('Update')),
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
      {super.key, required this.tileName, required this.value});

  final String tileName;
  final String value;

  @override
  State<Update_Maintenance_List_Tile> createState() =>
      _Update_Maintenance_List_TileState();
}

class _Update_Maintenance_List_TileState
    extends State<Update_Maintenance_List_Tile> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var _currentValue;

  @override
  Widget build(BuildContext context) {
    var initialValue = widget.tileName == "Mileage"
        ? globals.serviceHistory[widget.value][0][widget.tileName].toString()
        : widget.tileName == "Engine Oil"
            ? globals.serviceHistory[widget.value][1][widget.tileName]
                .toString()
            : widget.tileName == "Break Pads"
                ? globals.serviceHistory[widget.value][2][widget.tileName]
                    .toString()
                : widget.tileName == "Air Filter"
                    ? globals.serviceHistory[widget.value][3][widget.tileName]
                        .toString()
                    : widget.tileName == "Alignment"
                        ? globals.serviceHistory[widget.value][4]
                                [widget.tileName]
                            .toString()
                        : widget.tileName == "Battery"
                            ? globals.serviceHistory[widget.value][5]
                                    [widget.tileName]
                                .toString()
                            : widget.tileName == "Coolant"
                                ? globals.serviceHistory[widget.value][6]
                                        [widget.tileName]
                                    .toString()
                                : widget.tileName == "Spark Plugs"
                                    ? globals.serviceHistory[widget.value][7]
                                            [widget.tileName]
                                        .toString()
                                    : widget.tileName == "Tyres"
                                        ? globals.serviceHistory[widget.value]
                                                [8][widget.tileName]
                                            .toString()
                                        : widget.tileName ==
                                                "Transmission Fluid"
                                            ? globals
                                                .serviceHistory[widget.value][9]
                                                    [widget.tileName]
                                                .toString()
                                            : "";

    return ListTile(
      leading: Icon(Icons.car_repair, color: Colors.blueGrey[800]),
      title: Text(
        widget.tileName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
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
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.tileName,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                            child: TextFormField(
                              initialValue:
                                  initialValue,
                              decoration: InputDecoration(
                                hintText: widget.tileName,
                                hintStyle: TextStyle(color: Colors.black),
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
                            padding: EdgeInsets.only(top: 20.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {}
                                  setState(() {
                                    globals.serviceHistory[widget.tileName] =
                                        _currentValue;
                                  });

                                  Navigator.pop(context);
                                },
                                child: const Text('Update')),
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
