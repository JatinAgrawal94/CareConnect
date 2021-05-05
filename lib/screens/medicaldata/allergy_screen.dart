import 'package:careconnect/components/allergyList.dart';
import 'package:careconnect/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class AllergyScreen extends StatefulWidget {
  final String patientId;
  AllergyScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _AllergyScreenState createState() => _AllergyScreenState(patientId);
}

class _AllergyScreenState extends State<AllergyScreen> {
  final String patientId;
  _AllergyScreenState(this.patientId);
  PatientData _patientData = PatientData();
  DateTime selecteddate = DateTime.now();
  String type = "";
  CollectionReference allergy;
  @override
  void initState() {
    super.initState();
    setState(() {
      allergy =
          FirebaseFirestore.instance.collection('Patient/$patientId/allergy');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _setDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selecteddate, // Refer step 1
        firstDate: DateTime(1950),
        lastDate: DateTime(2030),
        builder: (BuildContext context, child) {
          return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  surface: Colors.deepPurple,
                  onSurface: Colors.deepPurple,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child);
        });
    if (picked != null && picked != selecteddate)
      setState(() {
        selecteddate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Allergy'),
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
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.all(5),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Type",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              )),
                          TextFormField(
                            cursorColor: Colors.deepPurple,
                            onChanged: (value) {
                              setState(() {
                                type = value;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Field can't be empty";
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.deepPurple))),
                            keyboardType: TextInputType.text,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Date",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}"
                                        .split(' ')[0],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.deepPurple),
                                      onPressed: () {
                                        _setDate(context);
                                      },
                                      child: Text(
                                        "Change",
                                        style: TextStyle(fontSize: 18),
                                      ))
                                ],
                              )),
                          Container(
                              alignment: Alignment.topLeft,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple),
                                onPressed: () async {
                                  await _patientData.addAllergyData(patientId, {
                                    'type': type,
                                    'date':
                                        "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}"
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
                                },
                                child: Text(
                                  "Add",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ))),
// ----------------------------------------------------------------------------------------------------------
              Container(
                  child: StreamBuilder<QuerySnapshot>(
                stream: allergy.snapshots(),
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
                      return AllergyList(
                          type: document.data()['type'],
                          date: document.data()['date']);
                    }).toList(),
                  );
                },
              )),
            ],
          ),
        ));
  }
}
