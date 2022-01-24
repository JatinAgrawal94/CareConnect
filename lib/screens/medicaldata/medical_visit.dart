import 'package:careconnect/components/loading.dart';
import 'package:careconnect/components/medical_visit.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MedicalVisitScreen extends StatefulWidget {
  final String patientId;
  MedicalVisitScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _MedicalVisitScreenState createState() => _MedicalVisitScreenState(patientId);
}

class _MedicalVisitScreenState extends State<MedicalVisitScreen> {
  final String patientId;
  String date = '';
  int visitType = 0;
  String doctor = '';
  String place = '';
  _MedicalVisitScreenState(this.patientId);
  PatientData _patientData = PatientData();
  DateTime selecteddate = DateTime.now();
  CollectionReference visit;

  @override
  void initState() {
    super.initState();
    setState(() {
      visit = FirebaseFirestore.instance
          .collection('Patient/$patientId/medicalvisit');
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
            title: Text('Medical Visit'),
            backgroundColor: Colors.deepPurple,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('New Appointment')),
                Tab(child: Text('Previous Appointments')),
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
                        margin: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text("Date", style: TextStyle(fontSize: 20)),
                            IconButton(
                                icon: Icon(Icons.date_range),
                                onPressed: () {
                                  _setDate(context);
                                }),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                  style: TextStyle(fontSize: 20),
                                )),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              Text("Visit Type",
                                  style: TextStyle(fontSize: 20)),
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                          activeColor: Colors.deepPurple,
                                          value: 0,
                                          groupValue: visitType,
                                          onChanged: (value) {
                                            setState(() {
                                              visitType = value;
                                            });
                                          }),
                                      Text("New",
                                          style: TextStyle(fontSize: 20)),
                                      Radio(
                                          activeColor: Colors.deepPurple,
                                          value: 1,
                                          groupValue: visitType,
                                          onChanged: (value) {
                                            setState(() {
                                              visitType = value;
                                            });
                                          }),
                                      Text("Follow Up",
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ))
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text("Doctor", style: TextStyle(fontSize: 20)),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                width: MediaQuery.of(context).size.width * 0.5,
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
                                            hintText: "Enter Doctor",
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.deepPurple))))))
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Row(children: <Widget>[
                            Text("Place", style: TextStyle(fontSize: 20)),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                width: MediaQuery.of(context).size.width * 0.5,
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
                                            hintText: "Enter Place",
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.deepPurple)))))),
                          ])),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple),
                          onPressed: () async {
                            if (doctor != "" && place != "") {
                              await _patientData.addMedicalVisit(patientId, {
                                'date':
                                    "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                'visitType':
                                    visitType == 0 ? "New" : "Follow Up",
                                'doctor': doctor,
                                'place': place
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
                          child: Text("Save", style: TextStyle(fontSize: 20)))
                    ],
                  )),
              Container(
                  padding: EdgeInsets.all(5),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: visit.snapshots(),
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
                          return MedicalVisitList(
                              visitType: document.data()['visitType'],
                              doctor: document.data()['doctor'],
                              place: document.data()['place'],
                              date: document.data()['date']);
                        }).toList(),
                      );
                    },
                  ))
            ],
          ),
        ));
  }
}
