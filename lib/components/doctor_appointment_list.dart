import 'package:careconnect/components/appointment_patientlist.dart';
import 'package:flutter/material.dart';

class DoctorAppointmentComponent extends StatefulWidget {
  final String date;
  final String noOfpatients;
  final String doctoremail;
  DoctorAppointmentComponent(
      {Key key, this.date, this.noOfpatients, this.doctoremail})
      : super(key: key);

  @override
  State<DoctorAppointmentComponent> createState() =>
      _DoctorAppointmentComponentState(
          this.date, this.noOfpatients, this.doctoremail);
}

class _DoctorAppointmentComponentState
    extends State<DoctorAppointmentComponent> {
  String date;
  String noOfpatients;
  String doctoremail;
  _DoctorAppointmentComponentState(
      this.date, this.noOfpatients, this.doctoremail);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(date, style: TextStyle(fontSize: 25)),
                Text("Patients: $noOfpatients", style: TextStyle(fontSize: 20))
              ],
            )),
        Container(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppointmentPatientList(
                                  doctoremail: doctoremail, date: date)));
                    },
                    child: Text('View'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple, fixedSize: Size(90, 20))),
                ElevatedButton(
                    onPressed: () {},
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple, fixedSize: Size(90, 20))),
              ],
            )),
      ],
    ));
  }
}
