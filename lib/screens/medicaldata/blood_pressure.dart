import 'package:careconnect/components/blood_pressure_list.dart';
import 'package:careconnect/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodPressureScreen extends StatefulWidget {
  final String patientId;
  BloodPressureScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _BloodPressureScreenState createState() =>
      _BloodPressureScreenState(patientId);
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  final String patientId;
  String systolic = "";
  String diastolic = "";
  String pulse = "";
  DateTime selecteddate = DateTime.now();
  TimeOfDay selectedtime = TimeOfDay.now();
  _BloodPressureScreenState(this.patientId);
  PatientData _patientData = PatientData();
  CollectionReference bloodpressure;
  @override
  void initState() {
    super.initState();
    setState(() {
      bloodpressure = FirebaseFirestore.instance
          .collection('Patient/$patientId/bloodpressure');
    });
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

  _setTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedtime,
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
            title: Text('Blood Pressure'),
            backgroundColor: Colors.deepPurple,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('New Reading')),
                Tab(child: Text('Previous Reading')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Reading",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Form(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Form(
                          child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              systolic = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(hintText: "systolic"),
                        ),
                      )),
                      Form(
                          child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              diastolic = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(hintText: "diastolic"),
                        ),
                      )),
                      Form(
                          child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              pulse = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(hintText: "pulse"),
                        ),
                      ))
                    ],
                  )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () {
                              _setDate(context);
                            },
                          ),
                          Text("12/04/2021", style: TextStyle(fontSize: 20)),
                          IconButton(
                              icon: Icon(Icons.timer_rounded),
                              onPressed: () {
                                _setTime(context);
                              }),
                          Text("05:21 PM", style: TextStyle(fontSize: 20))
                        ],
                      )),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.deepPurple),
                      onPressed: () async {
                        _patientData.addBloodPressure(patientId, {
                          'systolic': systolic,
                          "diastolic": diastolic,
                          "pulse": pulse,
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
                      child: Text("Save", style: TextStyle(fontSize: 20)))
                ]),
              ),
              Container(
                  child: StreamBuilder<QuerySnapshot>(
                stream: bloodpressure.snapshots(),
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
                      return BloodPressureList(
                        systolic: document.data()['systolic'],
                        diastolic: document.data()['diastolic'],
                        pulse: document.data()['pulse'],
                        date: document.data()['date'],
                        time: document.data()['time'],
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
