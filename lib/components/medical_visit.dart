import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class MedicalVisitList extends StatefulWidget {
  final String visitType;
  final String doctor;
  final String place;
  final String date;
  final String patientId;
  final String recordId;

  MedicalVisitList(
      {Key key,
      this.visitType,
      this.doctor,
      this.place,
      this.date,
      this.patientId,
      this.recordId})
      : super(key: key);

  @override
  _MedicalVisitListState createState() => _MedicalVisitListState(this.visitType,
      this.doctor, this.place, this.date, this.patientId, this.recordId);
}

class _MedicalVisitListState extends State<MedicalVisitList> {
  final String visitType;
  final String doctor;
  final String place;
  final String date;
  final String patientId;
  final String recordId;
  PatientData _patientData = PatientData();

  _MedicalVisitListState(this.visitType, this.doctor, this.place, this.date,
      this.patientId, this.recordId);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      height: MediaQuery.of(context).size.height * 0.1,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("$visitType", style: TextStyle(fontSize: 20)),
                Text("$date", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("$doctor", style: TextStyle(fontSize: 20)),
                Text("$place", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    await _patientData.deleteAnyPatientRecord(
                        patientId, recordId, "medicalvisit");
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.deepPurple,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
