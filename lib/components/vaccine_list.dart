import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class VaccineList extends StatefulWidget {
  final String vaccine;
  final String date;
  final String patientId;
  final String recordId;
  final String approved;
  final String role;
  VaccineList(
      {Key key,
      this.vaccine,
      this.date,
      this.patientId,
      this.recordId,
      this.approved,
      this.role})
      : super(key: key);

  @override
  _VaccineListState createState() => _VaccineListState(this.vaccine, this.date,
      this.patientId, this.recordId, this.approved, this.role);
}

class _VaccineListState extends State<VaccineList> {
  final String vaccine;
  final String date;
  final String patientId;
  final String recordId;
  final String approved;
  final String role;
  final PatientData _patientData = PatientData();
  _VaccineListState(this.vaccine, this.date, this.patientId, this.recordId,
      this.approved, this.role);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          color: approved == 'false' ? Colors.grey[200] : Colors.white,
        ),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Text("$vaccine", style: TextStyle(fontSize: 20)),
                    Text("$date", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              Column(children: [
                IconButton(
                  onPressed: () async {
                    await _patientData.deleteAnyPatientRecord(
                        patientId, recordId, "vaccine");
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.deepPurple,
                )
              ])
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                                patientId, recordId, 'vaccine', approved);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: approved == 'false'
                                  ? Colors.green
                                  : Colors.red),
                          child: approved == 'false'
                              ? Text("Verify")
                              : Text("Unverify")))
            ],
          )
        ]));
  }
}
