import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class AllergyList extends StatelessWidget {
  final String type;
  final String date;
  final String patientId;
  final String recordId;
  AllergyList({Key key, this.type, this.date , this.patientId, this.recordId})
      : super(key: key);
  final PatientData _patientData = PatientData();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: Colors.white, border: Border.all(width: 0.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Type: $type",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "Date:$date",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18),
                )
              ]),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    await _patientData.deleteAnyPatientRecord(
                        patientId, recordId, "allergy");
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.deepPurple,
                )
              ])
        ],
      ),
    );
  }
}
