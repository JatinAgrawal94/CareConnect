import 'package:careconnect/components/prescription_list.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:careconnect/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrescriptionScreen extends StatefulWidget {
  final String patientId;
  PrescriptionScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState(patientId);
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final String patientId;
  String drug;
  String dose;
  String doctor;
  String place;
  _PrescriptionScreenState(this.patientId);
  PatientData _patientData = PatientData();
  CollectionReference prescription;
  @override
  void initState() {
    super.initState();
    setState(() {
      prescription = FirebaseFirestore.instance
          .collection('Patient/$patientId/prescription');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Prescription'),
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
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Form(
                              child: Container(
                            margin: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              cursorColor: Colors.deepPurple,
                              onChanged: (value) {
                                setState(() {
                                  drug = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  hintText: "Drug",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.deepPurple))),
                            ),
                          )),
                          Form(
                              child: Container(
                            margin: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              cursorColor: Colors.deepPurple,
                              onChanged: (value) {
                                setState(() {
                                  dose = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  hintText: "Dose",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.deepPurple))),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                "Doctor",
                                style: TextStyle(fontSize: 20),
                              )),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Form(
                              child: TextFormField(
                                cursorColor: Colors.deepPurple,
                                onChanged: (value) {
                                  setState(() {
                                    doctor = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: "Doctor",
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.deepPurple))),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                "Place",
                                style: TextStyle(fontSize: 20),
                              )),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Form(
                              child: TextFormField(
                                cursorColor: Colors.deepPurple,
                                onChanged: (value) {
                                  setState(() {
                                    place = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: "Place",
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.deepPurple))),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(Icons.camera_alt, size: 30),
                            Icon(Icons.video_call_rounded, size: 30),
                            Icon(Icons.attach_file_outlined, size: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple),
                              onPressed: () async {
                                if (drug != null &&
                                    dose != null &&
                                    doctor != null &&
                                    place != null) {
                                  await _patientData
                                      .addPrescription(patientId, {
                                    'drug': drug,
                                    'dose': dose,
                                    'doctor': doctor,
                                    'place': place,
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
                                      msg: "Field Empty!",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.SNACKBAR,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 15,
                                      timeInSecForIosWeb: 1);
                                }
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: prescription.snapshots(),
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
                          return PrescriptionList(
                            drug: document.data()['drug'],
                            dose: document.data()['dose'],
                            doctor: document.data()['doctor'],
                            place: document.data()['place'],
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
