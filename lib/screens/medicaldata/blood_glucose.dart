import 'package:careconnect/components/blood_glucose_List.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodGlucoseScreen extends StatefulWidget {
  final String patientId;
  BloodGlucoseScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _BloodGlucoseScreenState createState() => _BloodGlucoseScreenState(patientId);
}

class _BloodGlucoseScreenState extends State<BloodGlucoseScreen> {
  final String patientId;
  _BloodGlucoseScreenState(this.patientId);
  PatientData _patientData = PatientData();
  int readingType = 0;
  DateTime selecteddate = DateTime.now();
  TimeOfDay selectedtime = TimeOfDay.now();
  String result = "";
  String resultUnit = 'mg/dL';
  List bloodGlucoseList = [];
  CollectionReference bloodglucose;
  @override
  void initState() {
    super.initState();
    setState(() {
      bloodglucose = FirebaseFirestore.instance
          .collection('Patient/$patientId/bloodglucose');
    });
  }

  _setDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selecteddate, // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selecteddate)
      setState(() {
        selecteddate = picked;
      });
  }

  _setTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedtime);
    if (picked != null) {
      setState(() {
        selectedtime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Blood Glucose'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New Reading')),
                Tab(child: Text('Previous Reading')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text(
                        "Type",
                        style: TextStyle(fontSize: 18),
                      )
                    ]),
                    Row(
                      children: <Widget>[
                        Radio(
                            value: 0,
                            groupValue: readingType,
                            onChanged: (val) {
                              setState(() {
                                readingType = val;
                              });
                            }),
                        Text("Fasting", style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                            value: 1,
                            groupValue: readingType,
                            onChanged: (val) {
                              setState(() {
                                readingType = val;
                              });
                            }),
                        Text("Postpradial", style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                            value: 2,
                            groupValue: readingType,
                            onChanged: (val) {
                              setState(() {
                                readingType = val;
                              });
                            }),
                        Text("Random", style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Results", style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Form(
                            child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Field can't be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  result = value;
                                });
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(width: 1)))),
                        )),
                        DropdownButton<String>(
                          value: resultUnit,
                          items: <String>['mg/dL', 'mmol/L']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              child:
                                  Text(value, style: TextStyle(fontSize: 18)),
                              value: value,
                            );
                          }).toList(),
                          hint: Text("Unit"),
                          onChanged: (String value) {
                            setState(() {
                              resultUnit = value;
                            });
                          },
                        )
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.date_range_outlined),
                              onPressed: () {
                                _setDate(context);
                              },
                            ),
                            Text(
                                "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}"
                                    .split(' ')[0],
                                style: TextStyle(fontSize: 18)),
                            IconButton(
                              icon: Icon(Icons.timer),
                              onPressed: () {
                                _setTime(context);
                              },
                            ),
                            Text(
                                "${selectedtime.hour.toString()}:${selectedtime.minute.toString()}",
                                style: TextStyle(fontSize: 18)),
                          ],
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          _patientData.addBloodGlucose(patientId, {
                            'type': readingType == 0
                                ? 'Fasting'
                                : readingType == 1
                                    ? "Postpradial"
                                    : "Random",
                            'result': result,
                            'resultUnit': resultUnit,
                            'date':
                                "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                            'time':
                                "${selectedtime.hour.toString()}:${selectedtime.minute.toString()}",
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
                          "Save",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
              ),
              Container(
                  child: StreamBuilder<QuerySnapshot>(
                stream: bloodglucose.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return BloodGlucoseList(
                        type: document.data()['type'],
                        result: document.data()['result'],
                        date: document.data()['date'],
                        time: document.data()['time'],
                        resultUnit: document.data()['resultUnit'],
                      );
                    }).toList(),
                  );
                },
              ))
            ],
          ),
        ));
  }
}
