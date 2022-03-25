import 'package:careconnect/components/doctor_appointment_list.dart';
import 'package:careconnect/components/loading.dart';
// import 'package:careconnect/screens/userdataforms/doctor_appointmentform.dart';
import 'package:careconnect/services/doctorData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Page showing list of dates doctor has appointments.

class DoctorAppointment extends StatefulWidget {
  final String doctorId;
  final String email;
  DoctorAppointment({Key key, this.doctorId, this.email}) : super(key: key);

  @override
  State<DoctorAppointment> createState() =>
      _DoctorAppointmentState(this.doctorId, this.email);
}

class _DoctorAppointmentState extends State<DoctorAppointment> {
  final String doctorId;
  final String email;
  _DoctorAppointmentState(this.doctorId, this.email);
  DoctorData _doctorData = DoctorData();
  CollectionReference appointment;
  List date = [];
  var check = 0;
  var dateOccurence = {};
  var timing = "Time";
  var doctoremail;
  List documentId = [];

  @override
  void initState() {
    super.initState();
    _doctorData.getAppointmentDates(email).then((value) {
      if (mounted) {
        if (value != null) {
          setState(() {
            date = value[0];
            dateOccurence = value[1];
            timing = value[2];
            doctoremail = value[3];
          });
        } else {
          setState(() {
            check = 1;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //     child: Icon(Icons.add),
        //     backgroundColor: Colors.deepPurple,
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (BuildContext context) => DoctorAppointmentForm(
        //                     doctorId: doctorId,
        //                   )));
        //     }),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.deepPurple,
          title: Text("Doctor Appointment"),
        ),
        body: timing == 'Time' && check == 0
            ? LoadingHeart()
            : check == 1
                ? Container(
                    child: Center(
                    child: Text("No Appointments",
                        style: TextStyle(color: Colors.grey)),
                  ))
                : Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.deepPurple),
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Text(
                              timing,
                              style: TextStyle(fontSize: 24),
                            )),
                        SingleChildScrollView(
                            child: Column(
                          children: List.generate(date.length, (index) {
                            return DoctorAppointmentComponent(
                              date: date[index],
                              noOfpatients:
                                  dateOccurence[date[index]].toString(),
                              doctoremail: doctoremail,
                            );
                          }),
                        ))
                      ],
                    ),
                  )
        // body:
        );
  }
}
