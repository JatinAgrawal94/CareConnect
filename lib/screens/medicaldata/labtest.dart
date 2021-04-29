import 'package:careconnect/components/labtest_list.dart';
import 'package:careconnect/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LabTestScreen extends StatefulWidget {
  final String patientId;
  LabTestScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _LabTestScreenState createState() => _LabTestScreenState(patientId);
}

class _LabTestScreenState extends State<LabTestScreen> {
  final String patientId;
  String test = '';
  String result = '';
  String normal = '';
  String doctor = '';
  String place = '';

  _LabTestScreenState(this.patientId);
  PatientData _patientData = PatientData();
  CollectionReference labtest;
  DateTime selecteddate = DateTime.now();
  @override
  void initState() {
    super.initState();
    setState(() {
      labtest =
          FirebaseFirestore.instance.collection('Patient/$patientId/labtest');
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
            title: Text('LabTest'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New Tests')),
                Tab(child: Text('Previous Tests')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Form(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                test = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(hintText: "Test"),
                          ),
                        )),
                        Form(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                result = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(hintText: "Result"),
                          ),
                        )),
                        Form(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                normal = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(hintText: "Normal"),
                          ),
                        ))
                      ],
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Doctor",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Form(
                                child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  doctor = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Doctor"),
                            )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Place",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Form(
                                child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  place = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Place"),
                            )),
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 30),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.date_range, size: 30),
                                onPressed: () {
                                  _setDate(context);
                                }),
                            Text("23/04/2021", style: TextStyle(fontSize: 20)),
                          ],
                        )),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(Icons.camera_alt, size: 30),
                          Icon(Icons.video_call_rounded, size: 30),
                          Icon(Icons.attach_file_outlined, size: 30),
                          ElevatedButton(
                            onPressed: () async {
                              await _patientData.addLabTest(patientId, {
                                'test': test,
                                'result': result,
                                'normal': normal,
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
                            child: Text("Save"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: labtest.snapshots(),
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
                        return LabTestList(
                            test: document.data()['test'],
                            result: document.data()['result'],
                            normal: document.data()['normal'],
                            doctor: document.data()['doctor'],
                            place: document.data()['place'],
                            date: document.data()['date']);
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
