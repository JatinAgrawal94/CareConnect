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
  final String role;
  final String approved;

  BloodPressureList(
      {Key key,
      this.systolic,
      this.diastolic,
      this.pulse,
      this.date,
      this.time,
      this.patientId,
      this.recordId,
      this.role,
      this.approved})
      : super(key: key);

  @override
  _BloodPressureListState createState() => _BloodPressureListState(
      this.systolic,
      this.diastolic,
      this.pulse,
      this.date,
      this.time,
      this.patientId,
      this.recordId,
      this.role,
      this.approved);
}

class _BloodPressureListState extends State<BloodPressureList> {
  final String systolic;
  final String diastolic;
  final String pulse;
  final String date;
  final String time;
  final String patientId;
  final String recordId;
  final String role;
  final String approved;
  final PatientData _patientData = PatientData();

  _BloodPressureListState(this.systolic, this.diastolic, this.pulse, this.date,
      this.time, this.patientId, this.recordId, this.role, this.approved);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        color: approved == 'false' ? Colors.grey[200] : Colors.white,
      ),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("$date", style: TextStyle(fontSize: 20)),
                Text("$time", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          Container(
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
            child: Column(children: [
              IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.deepPurple,
                  onPressed: () async {
                    await _patientData.deleteAnyPatientRecord(
                        patientId, recordId, "bloodpressure");
                  }),
              role == "patient" || role == null
                  ? Container(
                      child: (approved == 'false'
                          ? Text(
                              "Waiting for Approval",
                              style: TextStyle(color: Colors.grey),
                            )
                          : Text(
                              "Approved",
                              style: TextStyle(color: Colors.green),
                            )))
                  : Container(
                      child: ElevatedButton(
                          onPressed: () async {
                            await _patientData.updateApprovalStatus(
                                patientId, recordId, 'bloodpressure', approved);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: approved == 'false'
                                  ? Colors.green
                                  : Colors.red),
                          child: approved == 'false'
                              ? Text("Verify")
                              : Text("Unverify")))
            ]),
          )
        ],
      ),
    );
  }
}
