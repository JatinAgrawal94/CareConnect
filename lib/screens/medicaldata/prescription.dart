import 'package:careconnect/components/prescription_list.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:careconnect/services/doctordata.dart';
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
  int frequency = 0;
  List<String> timings = [];
  TimeOfDay selectedtime = TimeOfDay.now();
  DateTime selecteddate = DateTime.now();
  List<String> data = [];
  _PrescriptionScreenState(this.patientId);
  PatientData _patientData = PatientData();
  DoctorData _doctorData = DoctorData();
  CollectionReference prescription;

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
      prescription = FirebaseFirestore.instance
          .collection('Patient/$patientId/prescription');
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
                  primary: Colors.white,
                  onPrimary: Colors.deepPurple[300],
                  surface: Colors.deepPurple,
                  onSurface: Colors.black,
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
                        padding: EdgeInsets.all(5),
                        child: Row(children: <Widget>[
                          Text(
                            "Doctor",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                              child: Container(
                                  child: DropdownButton<String>(
                                value: doctor,
                                items: data.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                      child: Text(value,
                                          style: TextStyle(fontSize: 18)),
                                      value: value);
                                }).toList(),
                                hint: Text("Select doctor"),
                                onChanged: (String value) {
                                  setState(() {
                                    doctor = value;
                                  });
                                },
                              ))),
                        ])),
                    // Container(
                    //     child: Row(children: <Widget>[
                    //   Text("Frequency", style: TextStyle(fontSize: 20)),
                    //   Container(
                    //     margin: EdgeInsets.all(5),
                    //     width: MediaQuery.of(context).size.width * 0.4,
                    //     child: TextFormField(
                    //       cursorColor: Colors.deepPurple,
                    //       onChanged: (value) {
                    //         try {
                    //           setState(() {
                    //             frequency = int.parse(value);
                    //           });
                    //         } catch (err) {
                    //           Fluttertoast.showToast(
                    //               msg: "Enter integer value",
                    //               toastLength: Toast.LENGTH_LONG,
                    //               gravity: ToastGravity.SNACKBAR,
                    //               backgroundColor: Colors.grey,
                    //               textColor: Colors.white,
                    //               fontSize: 15,
                    //               timeInSecForIosWeb: 1);
                    //         }
                    //       },
                    //       keyboardType: TextInputType.number,
                    //       style: TextStyle(fontSize: 20),
                    //       decoration: InputDecoration(
                    //           hintText: "Frequency",
                    //           focusedBorder: UnderlineInputBorder(
                    //               borderSide: BorderSide(
                    //                   width: 1, color: Colors.deepPurple))),
                    //     ),
                    //   )
                    // ])),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.date_range,
                                  color: Colors.deepPurple),
                              onPressed: () {
                                _setDate(context);
                              },
                            ),
                            Text(
                                "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                style: TextStyle(fontSize: 20)),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.timer_rounded,
                                    color: Colors.deepPurple),
                                onPressed: () {
                                  _setTime(context);
                                }),
                            Text(
                                "${selectedtime.hour > 12 ? ((selectedtime.hour - 12).toString()) : (selectedtime.hour)}:${selectedtime.minute < 10 ? ("0${selectedtime.minute}") : (selectedtime.minute)}" +
                                    "  " +
                                    "${selectedtime.hour > 12 ? ("PM") : ("AM")}",
                                style: TextStyle(fontSize: 20)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    timings.add(
                                        "${selectedtime.hour > 12 ? ((selectedtime.hour - 12).toString()) : (selectedtime.hour)}:${selectedtime.minute < 10 ? ("0${selectedtime.minute}") : (selectedtime.minute)}" +
                                            "  " +
                                            "${selectedtime.hour > 12 ? ("PM") : ("AM")}");
                                  });
                                },
                                icon: Icon(Icons.add_circle,
                                    color: Colors.deepPurple))
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
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple),
                              onPressed: () async {
                                if (drug != null &&
                                    dose != null &&
                                    doctor != null) {
                                  await _patientData
                                      .addPrescription(patientId, {
                                    'drug': drug,
                                    'dose': dose,
                                    'doctor': doctor,
                                    'date':
                                        "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                    'timings': timings
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
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: timings.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              decoration:
                                  BoxDecoration(border: Border.all(width: 1)),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(timings[index],
                                          style: TextStyle(fontSize: 20))),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          timings.removeAt(index);
                                        });
                                      },
                                      icon: Icon(Icons.remove_circle))
                                ],
                              ));
                        },
                      ),
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
