import 'package:careconnect/components/family_list.dart';
import 'package:careconnect/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyHistoryScreen extends StatefulWidget {
  final String patientId;
  FamilyHistoryScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _FamilyHistoryScreenState createState() =>
      _FamilyHistoryScreenState(patientId);
}

class _FamilyHistoryScreenState extends State<FamilyHistoryScreen> {
  final String patientId;
  _FamilyHistoryScreenState(this.patientId);
  PatientData _patientData = PatientData();
  CollectionReference family;
  String memberName = '';
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String description = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      family = FirebaseFirestore.instance
          .collection('Patient/$patientId/familyhistory');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Family History'),
            backgroundColor: Colors.deepPurple,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Form(
                    key: formkey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.family_restroom, size: 30),
                            Text("Family Member History",
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            cursorColor: Colors.deepPurple,
                            onChanged: (value) {
                              setState(() {
                                memberName = value;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Field can't be empty";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Family Member Name",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.deepPurple))),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                              cursorColor: Colors.deepPurple,
                              onChanged: (value) {
                                setState(() {
                                  description = value;
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Field can't be empty";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Description",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.deepPurple)))),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple),
                            onPressed: () async {
                              if (formkey.currentState.validate()) {
                                await _patientData.addFamilyHistory(patientId, {
                                  'name': memberName,
                                  'description': description
                                });
                                Fluttertoast.showToast(
                                    msg: "Data Saved",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 15,
                                    timeInSecForIosWeb: 1);
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Error",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 15,
                                    timeInSecForIosWeb: 1);
                              }
                            },
                            child: Text("Save", style: TextStyle(fontSize: 20)))
                      ],
                    )),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: family.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingHeart();
                    }

                    return new ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return FamilyList(
                          name: document.data()['name'],
                          description: document.data()['description'],
                        );
                      }).toList(),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
