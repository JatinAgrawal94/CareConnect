import 'package:careconnect/components/appointment_list.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:careconnect/services/patientdata.dart';

class Appointment extends StatefulWidget {
  final String patientId;
  Appointment({Key key, this.patientId}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState(this.patientId);
}

class _AppointmentState extends State<Appointment> {
  final String patientId;
  _AppointmentState(this.patientId);
  String notes = "";
  String doctor = "";
  String place = "";
  int visitType = 0;
  DateTime selecteddate = DateTime.now();
  TimeOfDay selectedtime = TimeOfDay.now();
  PatientData _patientData = PatientData();
  CollectionReference appointment;

  @override
  void initState() {
    super.initState();
    setState(() {
      appointment = FirebaseFirestore.instance
          .collection('Patient/$patientId/appointment');
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
              title: Text("Appointment"),
              backgroundColor: Colors.deepPurple,
              bottom: TabBar(tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ])),
          body: TabBarView(children: [
            SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Text("Date:", style: TextStyle(fontSize: 20)),
                        IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () {
                            _setDate(context);
                          },
                        ),
                        Text(
                            "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.timer_sharp),
                          onPressed: () {
                            _setTime(context);
                          },
                        ),
                        Text(
                            "${selectedtime.hour.toString()}:${selectedtime.minute.toString()}",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Visit Type",
                          style: TextStyle(fontSize: 20),
                        ),
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
                                Text("New", style: TextStyle(fontSize: 20)),
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
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Row(children: <Widget>[
                        Text(
                          "Notes",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Form(
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    notes = value;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(hintText: "Notes"),
                              ),
                            )),
                      ])),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Row(children: <Widget>[
                        Text(
                          "Doctor",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                            width: MediaQuery.of(context).size.width * 0.7,
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
                      ])),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Row(children: <Widget>[
                        Text(
                          "Place",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                            width: MediaQuery.of(context).size.width * 0.7,
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
                      ])),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.deepPurple),
                      onPressed: () async {
                        await _patientData.addAppointment(patientId, {
                          'notes': notes,
                          'date':
                              "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                          'time':
                              "${selectedtime.hour.toString()}:${selectedtime.minute.toString()}",
                          'doctor': doctor,
                          'place': place,
                          'visitType': visitType == 0 ? "New" : "Follow Up"
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
                ],
              ),
            )),
            Container(
                padding: EdgeInsets.all(5),
                child: StreamBuilder<QuerySnapshot>(
                  stream: appointment.snapshots(),
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
                        return AppointmentList(
                          notes: document.data()['notes'],
                          doctor: document.data()['doctor'],
                          place: document.data()['place'],
                          date: document.data()['date'],
                          time: document.data()['time'],
                          visitType: document.data()['visitType'],
                        );
                      }).toList(),
                    );
                  },
                ))
          ]),
        ));
  }
}
