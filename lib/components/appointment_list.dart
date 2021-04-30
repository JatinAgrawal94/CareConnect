import 'package:flutter/material.dart';

class AppointmentList extends StatefulWidget {
  final String date;
  final String time;
  final String visitType;
  final String notes;
  final String doctor;
  final String place;

  AppointmentList(
      {Key key,
      this.date,
      this.time,
      this.visitType,
      this.notes,
      this.doctor,
      this.place})
      : super(key: key);

  @override
  _AppointmentListState createState() => _AppointmentListState(this.date,
      this.time, this.visitType, this.notes, this.doctor, this.place);
}

class _AppointmentListState extends State<AppointmentList> {
  final String date;
  final String time;
  final String visitType;
  final String notes;
  final String doctor;
  final String place;

  _AppointmentListState(this.date, this.time, this.visitType, this.notes,
      this.doctor, this.place);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "$date",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "$time",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
                Column(children: <Widget>[
                  Text(
                    "VisitType: $visitType",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "Doctor: $doctor",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "Place: $place",
                    style: TextStyle(fontSize: 17),
                  )
                ])
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("Note:$notes", style: TextStyle(fontSize: 14)),
                )
              ],
            )
          ],
        ));
  }
}
