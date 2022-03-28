import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class FamilyList extends StatefulWidget {
  final String name;
  final String description;
  final String patientId;
  final String recordId;
  final String role;
  final String approved;
  FamilyList(
      {Key key,
      this.name,
      this.description,
      this.patientId,
      this.recordId,
      this.role,
      this.approved})
      : super(key: key);

  @override
  _FamilyListState createState() => _FamilyListState(
      this.name,
      this.description,
      this.patientId,
      this.recordId,
      this.role,
      this.approved);
}

class _FamilyListState extends State<FamilyList> {
  String name;
  String description;
  final String patientId;
  final String recordId;
  final String role;
  final String approved;
  PatientData _patientData = PatientData();

  _FamilyListState(this.name, this.description, this.patientId, this.recordId,
      this.role, this.approved);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        color: approved == 'false' ? Colors.grey[200] : Colors.white,
      ),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: $name", style: TextStyle(fontSize: 20)),
                  Text(
                    "Description: $description",
                    style: TextStyle(fontSize: 20),
                    maxLines: 5,
                  ),
                ],
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            IconButton(
              onPressed: () async {
                await _patientData.deleteAnyPatientRecord(
                    patientId, recordId, "familyhistory");
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
                              patientId, recordId, 'familyhistory', approved);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: approved == 'false'
                                ? Colors.green
                                : Colors.red),
                        child: approved == 'false'
                            ? Text("Verify")
                            : Text("Unverify")))
          ]),
        ],
      ),
    );
  }
}
