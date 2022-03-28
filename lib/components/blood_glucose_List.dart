import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

// ignore: must_be_immutable
class BloodGlucoseList extends StatelessWidget {
  final String type;
  final String date;
  final String time;
  final String result;
  final String resultUnit;
  final String patientId;
  final String recordId;
  final role;
  final approved;

  BloodGlucoseList(
      {Key key,
      this.type,
      this.result,
      this.date,
      this.time,
      this.resultUnit,
      this.patientId,
      this.recordId,
      this.role,
      this.approved})
      : super(key: key);

  PatientData _patientData = PatientData();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: approved == 'false' ? Colors.grey[200] : Colors.white,
          border: Border.all(width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              child: Column(
            children: <Widget>[
              Text("$result $resultUnit", style: TextStyle(fontSize: 18)),
              Text("$date", style: TextStyle(fontSize: 18)),
            ],
          )),
          Container(
              child: Column(
            children: <Widget>[
              Text("Type:$type", style: TextStyle(fontSize: 18)),
              Text("$time", style: TextStyle(fontSize: 18))
            ],
          )),
          Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(children: <Widget>[
                IconButton(
                  onPressed: () async {
                    await _patientData.deleteAnyPatientRecord(
                        patientId, recordId, "bloodglucose");
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.deepPurple,
                ),
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
                              await _patientData.updateApprovalStatus(patientId,
                                  recordId, 'bloodglucose', approved);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: approved == 'false'
                                    ? Colors.green
                                    : Colors.red),
                            child: approved == 'false'
                                ? Text("Verify")
                                : Text("Unverify")))
              ]))
        ],
      ),
    );
  }
}
