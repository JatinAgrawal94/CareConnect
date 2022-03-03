import 'package:careconnect/services/patientdata.dart';
import 'package:flutter/material.dart';

class PrescriptionList extends StatefulWidget {
  final String drug;
  final String dose;
  final String doctor;
  final String date;
  final timing;
  final String patientId;
  final String prescriptionId;

  PrescriptionList(
      {Key key,
      this.drug,
      this.dose,
      this.doctor,
      this.date,
      this.timing,
      this.patientId,
      this.prescriptionId})
      : super(key: key);

  @override
  _PrescriptionListState createState() => _PrescriptionListState(
      this.drug,
      this.dose,
      this.doctor,
      this.date,
      this.timing,
      this.patientId,
      this.prescriptionId);
}

class _PrescriptionListState extends State<PrescriptionList> {
  final String drug;
  final String dose;
  final String doctor;
  final String date;
  final timing;
  final String patientId;
  final String prescriptionId;
  PatientData _patient = PatientData();
  _PrescriptionListState(this.drug, this.dose, this.doctor, this.date,
      this.timing, this.patientId, this.prescriptionId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$drug",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "$dose",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Doctor:$doctor",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Timings:" + timing[0] + " - " + timing[1] + " - " + timing[2],
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Column(children: <Widget>[
            Container(
              child: IconButton(
                iconSize: 30,
                color: Colors.deepPurple,
                icon: Icon(Icons.notification_add),
                onPressed: () {},
              ),
            ),
            Container(
              child: IconButton(
                iconSize: 30,
                color: Colors.deepPurple,
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await _patient.deleteAnyPatientRecord(
                      patientId, prescriptionId, 'prescription');
                },
              ),
            )
          ])
        ],
      ),
    );
  }
}
