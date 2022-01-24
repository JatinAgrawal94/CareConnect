import 'package:careconnect/components/examinationList.dart';
import 'package:careconnect/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ExaminationScreen extends StatefulWidget {
  final String patientId;
  final String userId;
  ExaminationScreen({Key key, @required this.patientId, this.userId})
      : super(key: key);

  @override
  _ExaminationScreenState createState() =>
      _ExaminationScreenState(patientId, this.userId);
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  final String patientId;
  final String userId;
  String category = "EX";
  _ExaminationScreenState(this.patientId, this.userId);
  PatientData _patientData = PatientData();
  PickedFile _mediaFile;
  DateTime selecteddate = DateTime.now();
  CollectionReference examination;
  String temperature = "";
  String weight = "";
  String height = "";
  String symptoms = "";
  String diagnosis = "";
  String notes = "";
  String doctor = "";
  String place = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      examination = FirebaseFirestore.instance
          .collection('Patient/$patientId/examination');
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Examination'),
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
              SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Temperature",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    cursorColor: Colors.deepPurple,
                                    onChanged: (value) {
                                      setState(() {
                                        temperature = value;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.deepPurple))),
                                  ))),
                              Text(
                                'C/F',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              )
                            ],
                          ),
                          Row(children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text("Weight",
                                    style: TextStyle(fontSize: 20))),
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Form(
                                    child: TextFormField(
                                  cursorColor: Colors.deepPurple,
                                  onChanged: (value) {
                                    setState(() {
                                      weight = value;
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.deepPurple))),
                                ))),
                            Text(
                              'Kg',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            )
                          ]),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Height",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    cursorColor: Colors.deepPurple,
                                    onChanged: (value) {
                                      setState(() {
                                        height = value;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.deepPurple))),
                                  ))),
                              Text(
                                'CM',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Symptoms",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    cursorColor: Colors.deepPurple,
                                    onChanged: (value) {
                                      setState(() {
                                        symptoms = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.deepPurple))),
                                  ))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Diagnosis",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    cursorColor: Colors.deepPurple,
                                    onChanged: (value) {
                                      setState(() {
                                        diagnosis = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.deepPurple))),
                                  ))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Notes",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    cursorColor: Colors.deepPurple,
                                    onChanged: (value) {
                                      setState(() {
                                        notes = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.deepPurple))),
                                  ))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Doctor",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    cursorColor: Colors.deepPurple,
                                    onChanged: (value) {
                                      setState(() {
                                        doctor = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.deepPurple))),
                                  ))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Place",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    cursorColor: Colors.deepPurple,
                                    onChanged: (value) {
                                      setState(() {
                                        place = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.deepPurple))),
                                  ))),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.all(5),
                              child: Row(children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.date_range_outlined,
                                        size: 30),
                                    onPressed: () {
                                      _setDate(context);
                                    }),
                                Text(
                                  "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                  style: TextStyle(fontSize: 20),
                                )
                              ])),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    // _patientData.showpicker(context);
                                    // _mediaFile = PatientData.media;
                                  }),
                              IconButton(
                                  icon: Icon(Icons.video_call, size: 35),
                                  onPressed: () {
                                    // _patientData.uploadPatientVideo(
                                    //     File(_mediaFile.path),
                                    //     "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                    //     category,
                                    //     userId);
                                  }),
                              IconButton(
                                  icon: Icon(Icons.attach_file, size: 35),
                                  onPressed: () {
                                    // _patientData.uploadPatientFile(
                                    //     File(_mediaFile.path),
                                    //     "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                    //     category,
                                    //     userId);
                                  })
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (temperature != "" &&
                                    weight != "" &&
                                    height != "" &&
                                    symptoms != "" &&
                                    diagnosis != "" &&
                                    notes != "" &&
                                    doctor != "" &&
                                    place != "") {
                                  _patientData.addExamination(patientId, {
                                    'temperature': temperature,
                                    'weight': weight,
                                    'height': height,
                                    'symptoms': symptoms,
                                    'diagnosis': diagnosis,
                                    'notes': notes,
                                    'doctor': doctor,
                                    'place': place,
                                    'date':
                                        "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                  });
                                  // _patientData.uploadPatientPhoto(
                                  //     File(_mediaFile.path),
                                  //     "${selecteddate.day}-${selecteddate.month}-${selecteddate.year}",
                                  //     category,
                                  //     userId);
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
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple),
                              child: Text("Save",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white))),
                        ],
                      ))),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: examination.snapshots(),
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
                        return ExaminationList(
                            temperature: document.data()['temperature'],
                            weight: document.data()['temperature'],
                            height: document.data()['height'],
                            symptoms: document.data()['symptoms'],
                            diagnosis: document.data()['diagnosis'],
                            notes: document.data()['notes'],
                            doctor: document.data()['doctor'],
                            date: document.data()['date'],
                            place: document.data()['place']);
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
