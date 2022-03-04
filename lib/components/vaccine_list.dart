import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class VaccineList extends StatefulWidget {
  final String vaccine;
  final String date;
  final String patientId;
  final String recordId;
  VaccineList({Key key, this.vaccine, this.date, this.patientId, this.recordId})
      : super(key: key);

  @override
  _VaccineListState createState() =>
      _VaccineListState(this.vaccine, this.date, this.patientId, this.recordId);
}

class _VaccineListState extends State<VaccineList> {
  final String vaccine;
  final String date;
  final String patientId;
  final String recordId;
  final PatientData _patientData = PatientData();
  _VaccineListState(this.vaccine, this.date, this.patientId, this.recordId);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      child: Row(
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
    );
  }
}
