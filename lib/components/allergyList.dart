import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class AllergyList extends StatelessWidget {
  final String type;
  final String date;
  final String patientId;
  final String recordId;
  final role;
  final approved;
  AllergyList(
      {Key key,
      this.type,
      this.date,
      this.patientId,
      this.recordId,
      this.role,
      this.approved})
      : super(key: key);
  final PatientData _patientData = PatientData();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: approved == 'false' ? Colors.grey[200] : Colors.white,
          border: Border.all(width: 0.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Type: $type",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "Date: $date",
                  style: TextStyle(fontSize: 18),
                )
              ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
            IconButton(
              onPressed: () async {
                await _patientData.deleteAnyPatientRecord(
                    patientId, recordId, "allergy");
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
                          await _patientData.updateApprovalStatus(
                              patientId, recordId, 'allergy', approved);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: approved == 'false'
                                ? Colors.green
                                : Colors.red),
                        child: approved == 'false'
                            ? Text("Verify")
                            : Text("Unverify")))
          ])
        ],
      ),
    );
  }
}
