import 'package:careconnect/components/appointment_list.dart';
import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/components/loading.dart';
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
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  _AppointmentState(this.patientId);
  String reason = "";
  String doctor;
  String paymentstatus = 'Unpaid';
  int visittype = 0;
  int appointmentType = 0;

  DateTime selecteddate = DateTime.now();
  PatientData _patientData = PatientData();
  GeneralFunctions general = GeneralFunctions();
  List<String> doctorList = ['Other'];
  List doctordata = [];
  var otherDoctor = 0;
  List appointmentList = [];
  var empty = 1;
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
      _patientData.getPatientAppointments(value['email']).then((value) {
        value.forEach((item) {
          setState(() {
            appointmentList.add(item);
          });
        });
        if (appointmentList.length == 0) {
          setState(() {
            empty = 0;
          });
        }
      });
    });
  }

  Future setData() async {
    var data = await _patientData.getPatientAppointments(patientdata['email']);
    setState(() {
      this.appointmentList = data;
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
            doctorList.length == 1
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
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      child: Text(
                                        "Doctor",
                                        style: TextStyle(fontSize: 20),
                                      )),
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
                                      if (value != 'Other') {
                                        setState(() {
                                          doctor = value;
                                          if (otherDoctor == 1) {
                                            otherDoctor = 0;
                                          }
                                        });
                                      } else {
                                        setState(() {
                                          otherDoctor = 1;
                                        });
                                      }
                                    },
                                  )),
                                ])),
                            otherDoctor != 0
                                ? Container(
                                    padding: EdgeInsets.all(5),
                                    child: Row(children: <Widget>[
                                      Text(
                                        "DoctorName",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(15, 0, 5, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: TextFormField(
                                          cursorColor: Colors.deepPurple,
                                          onChanged: (value) {
                                            setState(() {
                                              doctor = value;
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
                                              hintText: "Doctor Name",
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: Colors
                                                              .deepPurple))),
                                        ),
                                      ),
                                    ]))
                                : Container(width: 0, height: 0),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple),
                                onPressed: () async {
                                  var doctorindex = doctorList.indexOf(doctor);
                                  var status = await _patientData
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
                                        msg: "Appointment Booked!",
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
            appointmentList.length == 0 && empty == 1
                ? LoadingHeart()
                : empty == 0
                    ? EmptyRecord()
                    : Container(
                        padding: EdgeInsets.all(5),
                        child: RefreshIndicator(
                            onRefresh: setData,
                            color: Colors.deepPurple,
                            child: ListView.builder(
                                itemCount: appointmentList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (appointmentList[index]
                                          ['appointmenttype'] ==
                                      'Online') {
                                    return AppointmentList(
                                        reason: appointmentList[index]
                                            ['reason'],
                                        doctor: appointmentList[index]
                                            ['doctorname'],
                                        doctoremail: appointmentList[index]
                                            ['doctoremail'],
                                        paymentstatus: appointmentList[index]
                                            ['paymentstatus'],
                                        date: appointmentList[index]['date'],
                                        timing: appointmentList[index]
                                            ['timing'],
                                        visittype: appointmentList[index]
                                            ['visittype'],
                                        paymentamount: appointmentList[index]
                                            ['paymentamount'],
                                        appointmenttype: appointmentList[index]
                                            ['appointmenttype'],
                                        patientemail: appointmentList[index]
                                            ['patientemail'],
                                        zoomlink: appointmentList[index]
                                            ['zoom'],
                                        documentid: appointmentList[index]
                                            ['documentid']);
                                  } else {
                                    return AppointmentList(
                                        reason: appointmentList[index]
                                            ['reason'],
                                        doctor: appointmentList[index]
                                            ['doctorname'],
                                        doctoremail: appointmentList[index]
                                            ['doctoremail'],
                                        paymentstatus: appointmentList[index]
                                            ['paymentstatus'],
                                        date: appointmentList[index]['date'],
                                        timing: appointmentList[index]
                                            ['timing'],
                                        visittype: appointmentList[index]
                                            ['visittype'],
                                        paymentamount: appointmentList[index]
                                            ['paymentamount'],
                                        appointmenttype: appointmentList[index]
                                            ['appointmenttype'],
                                        patientemail: appointmentList[index]
                                            ['patientemail'],
                                        zoomlink: '',
                                        documentid: appointmentList[index]
                                            ['documentid']);
                                  }
                                })))
          ]),
        ));
  }
}
