import 'package:car_management/pages/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_management/components/globals.dart' as globals;

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
