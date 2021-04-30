import 'package:careconnect/components/radiology_list.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:careconnect/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RadiologyScreen extends StatefulWidget {
  final String patientId;
  RadiologyScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _RadiologyScreenState createState() => _RadiologyScreenState(patientId);
}

class _RadiologyScreenState extends State<RadiologyScreen> {
  final String patientId;
  String title;
  String result;
  String doctor;
  String place;
  _RadiologyScreenState(this.patientId);
  DateTime selecteddate = DateTime.now();
  PatientData _patientData = PatientData();
  CollectionReference radiology;

  @override
  void initState() {
    super.initState();
    setState(() {
      radiology =
          FirebaseFirestore.instance.collection('Patient/$patientId/radiology');
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Radiology'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(child:
              Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Form(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  title = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Title"),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Form(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  result = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Result"),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Form(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  doctor = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Doctor"),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Form(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  place = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Place"),
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.date_range, size: 30),
                              onPressed: () {
                                _setDate(context);
                              },
                            ),
                            Text(
                                "Date ${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                style: TextStyle(fontSize: 20))
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(Icons.camera_alt, size: 30),
                            Icon(Icons.video_call, size: 30),
                            Icon(Icons.attach_file, size: 30),
                            ElevatedButton(
                                onPressed: () async {
                                  await _patientData
                                      .addRadiologyData(patientId, {
                                    'title': title,
                                    'result': result,
                                    'doctor': doctor,
                                    'place': place,
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
                                  "Save",
                                  style: TextStyle(fontSize: 20),
                                ))
                          ],
                        ),
                      )
                    ],
                  ))),
              Container(
                  padding: EdgeInsets.all(5),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: radiology.snapshots(),
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
                          return RadiologyList(
                              title: document.data()['title'],
                              result: document.data()['result'],
                              doctor: document.data()['doctor'],
                              place: document.data()['place'],
                              date: document.data()['date'],
                              );
                        }).toList(),
                      );
                    },
                  )),
            ],
          ),
        ));
  }
}
