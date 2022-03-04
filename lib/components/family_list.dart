import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class FamilyList extends StatefulWidget {
  final String name;
  final String description;
  final String patientId;
  final String recordId;
  FamilyList(
      {Key key, this.name, this.description, this.patientId, this.recordId})
      : super(key: key);

  @override
  _FamilyListState createState() => _FamilyListState(
      this.name, this.description, this.patientId, this.recordId);
}

class _FamilyListState extends State<FamilyList> {
  String name;
  String description;
  final String patientId;
  final String recordId;
  PatientData _patientData = PatientData();

  _FamilyListState(this.name, this.description, this.patientId, this.recordId);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 0.5), color: Colors.white),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Name: $name", style: TextStyle(fontSize: 20)),
              Text("Description: $description", style: TextStyle(fontSize: 20)),
            ],
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    await _patientData.deleteAnyPatientRecord(
                        patientId, recordId, "familyhistory");
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
