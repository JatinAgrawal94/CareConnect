import 'package:careconnect/components/appointment_list.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:careconnect/services/doctordata.dart';

class Appointment extends StatefulWidget {
  final String patientId;
  Appointment({Key key, this.patientId}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState(this.patientId);
}

class _AppointmentState extends State<Appointment> {
  final String patientId;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  _AppointmentState(this.patientId);
  String reason = "";
  String doctor;
  String paymentstatus = 'Unpaid';
  int visittype = 0;
  int appointmentType = 0;

  DateTime selecteddate = DateTime.now();
  PatientData _patientData = PatientData();
  DoctorData _doctorData = DoctorData();
  GeneralFunctions general = GeneralFunctions();
  CollectionReference appointment;
  List<String> doctorList = [];
  List doctordata = [];
  var patientdata;
  @override
  void initState() {
    super.initState();
    // doctor name,timing,email
    general.getAllUser('doctor').then((value) {
      value.forEach((item) {
        setState(() {
          doctorList.add(item['name'] + '(' + item['timing'] + ')');
          doctordata.add({
            'name': item['name'],
            'timing': item['timing'],
            'email': item['email']
          });
        });
      });
    });
    general.getUserInfo(patientId, 'Patient').then((value) {
      setState(() {
        patientdata = {'name': value['name'], 'email': value['email']};
      });
    });
    setState(() {
      appointment = FirebaseFirestore.instance.collection('Appointment');
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
              title: Text("Appointment"),
              backgroundColor: Colors.deepPurple,
              bottom: TabBar(indicatorColor: Colors.white, tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ])),
          body: TabBarView(children: [
            doctorList == null
                ? LoadingHeart()
                : SingleChildScrollView(
                    child: Container(
                    padding: EdgeInsets.all(5),
                    child: Form(
                        key: formkey,
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
                                              groupValue: visittype,
                                              onChanged: (value) {
                                                setState(() {
                                                  visittype = value;
                                                });
                                              }),
                                          Text("New",
                                              style: TextStyle(fontSize: 20)),
                                          Radio(
                                              activeColor: Colors.deepPurple,
                                              value: 1,
                                              groupValue: visittype,
                                              onChanged: (value) {
                                                setState(() {
                                                  visittype = value;
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
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "AppointmentType",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                      // margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Row(
                                    children: <Widget>[
                                      Radio(
                                          activeColor: Colors.deepPurple,
                                          value: 0,
                                          groupValue: appointmentType,
                                          onChanged: (value) {
                                            setState(() {
                                              appointmentType = value;
                                            });
                                          }),
                                      Text("Offline",
                                          style: TextStyle(fontSize: 20)),
                                      Radio(
                                          activeColor: Colors.deepPurple,
                                          value: 1,
                                          groupValue: appointmentType,
                                          onChanged: (value) {
                                            setState(() {
                                              appointmentType = value;
                                            });
                                          }),
                                      Text("Online",
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
                                    "Reason",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: TextFormField(
                                      cursorColor: Colors.deepPurple,
                                      onChanged: (value) {
                                        setState(() {
                                          reason = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Field can't be Empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          hintText: "Reason",
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.deepPurple))),
                                    ),
                                  ),
                                ])),
                            Container(
                                padding: EdgeInsets.all(5),
                                child: Row(children: <Widget>[
                                  Text(
                                    "Doctor",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Expanded(
                                      child: DropdownButtonFormField<String>(
                                    value: doctor,
                                    items: doctorList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                          child: Text(value,
                                              style: TextStyle(fontSize: 15)),
                                          value: value);
                                    }).toList(),
                                    hint: Text("Select doctor"),
                                    onChanged: (String value) {
                                      setState(() {
                                        doctor = value;
                                      });
                                    },
                                  )),
                                ])),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple),
                                onPressed: () async {
                                  var doctorindex = doctorList.indexOf(doctor);
                                  var status = await _doctorData
                                      .checkUserValidityForAppointment(
                                          doctordata[doctorindex]['email'],
                                          patientdata['email'],
                                          "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}");
                                  if (status == 0) {
                                    Fluttertoast.showToast(
                                        msg: "Appointment limit reached",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.SNACKBAR,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 15,
                                        timeInSecForIosWeb: 1);
                                  } else if (formkey.currentState.validate() &&
                                      status == 1) {
                                    await _patientData
                                        .addAppointment(patientId, {
                                      'reason': reason,
                                      'date':
                                          "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                      'timing': doctordata[doctorindex]
                                          ['timing'],
                                      'doctorname': doctordata[doctorindex]
                                          ['name'],
                                      'doctoremail': doctordata[doctorindex]
                                          ['email'],
                                      'patientname': patientdata['name'],
                                      'patientemail': patientdata['email'],
                                      'paymentstatus': paymentstatus,
                                      'paymentamount': " ",
                                      'visittype':
                                          visittype == 0 ? "New" : "Follow Up",
                                      'appointmenttype': appointmentType == 0
                                          ? "Offline"
                                          : "Online"
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
                                        msg: "Error",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.SNACKBAR,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 15,
                                        timeInSecForIosWeb: 1);
                                  }
                                },
                                child: Text("Book",
                                    style: TextStyle(fontSize: 20)))
                          ],
                        )),
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
                        if (document.data()['appointmenttype'] == 'Online') {
                          return AppointmentList(
                              reason: document.data()['reason'],
                              doctor: document.data()['doctorname'],
                              doctoremail: document.data()['doctoremail'],
                              paymentstatus: document.data()['paymentstatus'],
                              date: document.data()['date'],
                              timing: document.data()['timing'],
                              visittype: document.data()['visittype'],
                              paymentamount: document.data()['paymentamount'],
                              appointmenttype:
                                  document.data()['appointmenttype'],
                              patientemail: document.data()['patientemail'],
                              zoomlink: document.data()['zoom']);
                        } else {
                          return AppointmentList(
                              reason: document.data()['reason'],
                              doctor: document.data()['doctorname'],
                              doctoremail: document.data()['doctoremail'],
                              paymentstatus: document.data()['paymentstatus'],
                              date: document.data()['date'],
                              timing: document.data()['timing'],
                              visittype: document.data()['visittype'],
                              paymentamount: document.data()['paymentamount'],
                              appointmenttype:
                                  document.data()['appointmenttype'],
                              patientemail: document.data()['patientemail'],
                              zoomlink: '');
                        }
                      }).toList(),
                    );
                  },
                ))
          ]),
        ));
  }
}
