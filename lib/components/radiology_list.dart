import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class RadiologyList extends StatefulWidget {
  final String title;
  final String result;
  final String doctor;
  final String date;
  final String place;
  final String patientId;
  final String recordId;
  RadiologyList(
      {Key key,
      this.title,
      this.result,
      this.doctor,
      this.date,
      this.place,
      this.patientId,
      this.recordId})
      : super(key: key);

  @override
  _RadiologyListState createState() => _RadiologyListState(
      this.title,
      this.result,
      this.doctor,
      this.date,
      this.place,
      this.patientId,
      this.recordId);
}

class _RadiologyListState extends State<RadiologyList> {
  final String title;
  final String result;
  final String doctor;
  final String date;
  final String place;
  final String patientId;
  final String recordId;
  PatientData _patientData = PatientData();

  _RadiologyListState(this.title, this.result, this.doctor, this.date,
      this.place, this.patientId, this.recordId);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text("$title", style: TextStyle(fontSize: 20))
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Result: $result", style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Place: $place", style: TextStyle(fontSize: 20))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Doctor: $doctor", style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("$date", style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    await _patientData.deleteAnyPatientRecord(
                        patientId, recordId, "radiology");
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.deepPurple,
                )
              ],
            )
          ],
        ));
  }
}
