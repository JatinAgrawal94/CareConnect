import 'package:careconnect/components/labtest_list.dart';
import 'package:careconnect/components/loading.dart';
import 'package:careconnect/services/doctorData.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class LabTestScreen extends StatefulWidget {
  final String patientId;
  LabTestScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _LabTestScreenState createState() => _LabTestScreenState(patientId);
}

class _LabTestScreenState extends State<LabTestScreen> {
  String category = "labtest";
  final String patientId;
  String test = '';
  String result = '';
  String normal = '';
  String doctor = '';
  String place = '';
  List<String> data = [];
  List images = [];
  List videos = [];
  List files = [];

  _LabTestScreenState(this.patientId);
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  PatientData _patientData = PatientData();
  DoctorData _doctorData = DoctorData();
  CollectionReference labtest;
  DateTime selecteddate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _doctorData.getAllDoctors().then((value) => {
          value.forEach((item) {
            setState(() {
              data.add(item['name']);
            });
          })
        });
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
            title: Text('LabTest'),
            backgroundColor: Colors.deepPurple,
            bottom: TabBar(
              indicatorColor: Colors.white,
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
                child: Form(
                    key: formkey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextFormField(
                                cursorColor: Colors.deepPurple,
                                onChanged: (value) {
                                  setState(() {
                                    test = value;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Field can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    hintText: "Test",
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.deepPurple))),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextFormField(
                                cursorColor: Colors.deepPurple,
                                onChanged: (value) {
                                  setState(() {
                                    result = value;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Field can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    hintText: "Result",
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.deepPurple))),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextFormField(
                                cursorColor: Colors.deepPurple,
                                onChanged: (value) {
                                  setState(() {
                                    normal = value;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Field can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    hintText: "Normal",
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.deepPurple))),
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: Row(
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
                                  child: DropdownButtonFormField(
                                    hint: Text(
                                      "Select Doctor",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    items: data.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                          child: Text(value,
                                              style: TextStyle(fontSize: 15)),
                                          value: value);
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        doctor = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (doctor == null) {
                                        return "Select doctor";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.deepPurple))),
                                  )),
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
                                child: TextFormField(
                                  cursorColor: Colors.deepPurple,
                                  onChanged: (value) {
                                    setState(() {
                                      place = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Field can't be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Place",
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.deepPurple))),
                                ),
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
                                Text(
                                    "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                    style: TextStyle(fontSize: 20)),
                              ],
                            )),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () async {
                                    final result = await FilePicker.platform
                                        .pickFiles(
                                            allowMultiple: true,
                                            type: FileType.custom,
                                            allowedExtensions: [
                                          'jpg',
                                          'jpeg',
                                          'png'
                                        ]);
                                    if (result != null) {
                                      images = await _patientData
                                          .prepareFiles(result.paths);
                                    } else {
                                      print("Error");
                                    }
                                  },
                                  icon: Icon(Icons.camera_alt, size: 30)),
                              IconButton(
                                  onPressed: () async {
                                    final result = await FilePicker.platform
                                        .pickFiles(
                                            allowMultiple: true,
                                            type: FileType.custom,
                                            allowedExtensions: [
                                          'mp4',
                                          'avi',
                                          'mkv'
                                        ]);
                                    if (result != null) {
                                      videos = await _patientData
                                          .prepareFiles(result.paths);
                                    } else {
                                      print("Error");
                                    }
                                  },
                                  icon:
                                      Icon(Icons.video_call_rounded, size: 35)),
                              IconButton(
                                  icon: Icon(Icons.attach_file, size: 32),
                                  onPressed: () async {
                                    final result = await FilePicker.platform
                                        .pickFiles(
                                            allowMultiple: true,
                                            type: FileType.custom,
                                            allowedExtensions: [
                                          'pdf',
                                          'doc',
                                        ]);
                                    if (result != null) {
                                      files = await _patientData
                                          .prepareFiles(result.paths);
                                    } else {
                                      print("Error");
                                    }
                                  }),
                            ],
                          ),
                        ),
                        Text(
                          "Media files should be less than 5MB",
                          style: TextStyle(fontSize: 15),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple),
                          onPressed: () async {
                            if (formkey.currentState.validate()) {
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
                            } else {}
                          },
                          child: Text("Save"),
                        ),
                      ],
                    )),
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
                            date: document.data()['date'],
                            patientId: patientId,
                            recordId: document.id);
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
