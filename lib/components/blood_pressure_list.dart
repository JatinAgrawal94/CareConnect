import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class BloodPressureList extends StatefulWidget {
  final String systolic;
  final String diastolic;
  final String pulse;
  final String date;
  final String time;
  final String patientId;
  final String recordId;

  BloodPressureList(
      {Key key,
      this.systolic,
      this.diastolic,
      this.pulse,
      this.date,
      this.time,
      this.patientId,
      this.recordId})
      : super(key: key);

  @override
  _BloodPressureListState createState() => _BloodPressureListState(
      this.systolic,
      this.diastolic,
      this.pulse,
      this.date,
      this.time,
      this.patientId,
      this.recordId);
}

class _BloodPressureListState extends State<BloodPressureList> {
  final String systolic;
  final String diastolic;
  final String pulse;
  final String date;
  final String time;
  final String patientId;
  final String recordId;
  final PatientData _patientData = PatientData();

  _BloodPressureListState(this.systolic, this.diastolic, this.pulse, this.date,
      this.time, this.patientId, this.recordId);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      height: MediaQuery.of(context).size.height * 0.1,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("$date", style: TextStyle(fontSize: 20)),
                Text("$time", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Reading", style: TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("$systolic", style: TextStyle(fontSize: 20)),
                    Text("$diastolic", style: TextStyle(fontSize: 20)),
                    Text("$pulse", style: TextStyle(fontSize: 20)),
                  ],
                )
              ],
            ),
          ),
          Container(
            child: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.deepPurple,
                onPressed: () async {
                  await _patientData.deleteAnyPatientRecord(
                      patientId, recordId, "bloodpressure");
                }),
          )
        ],
      ),
    );
  }
}
