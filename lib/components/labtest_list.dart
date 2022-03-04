import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class LabTestList extends StatefulWidget {
  final String test;
  final String result;
  final String normal;
  final String doctor;
  final String place;
  final String date;
  final String patientId;
  final String recordId;
  LabTestList(
      {Key key,
      this.test,
      this.result,
      this.normal,
      this.place,
      this.date,
      this.doctor,
      this.patientId,
      this.recordId})
      : super(key: key);

  @override
  _LabTestListState createState() => _LabTestListState(
      this.test,
      this.result,
      this.normal,
      this.place,
      this.date,
      this.doctor,
      this.patientId,
      this.recordId);
}

class _LabTestListState extends State<LabTestList> {
  final String test;
  final String result;
  final String normal;
  final String doctor;
  final String place;
  final String date;
  final String patientId;
  final String recordId;
  PatientData _patientData = PatientData();

  _LabTestListState(this.test, this.result, this.normal, this.place, this.date,
      this.doctor, this.patientId, this.recordId);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.26,
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("$test", style: TextStyle(fontSize: 20)),
                  Text("Date: $date", style: TextStyle(fontSize: 20)),
                  Text("Result:$result",
                      style: TextStyle(fontSize: 20), maxLines: 5),
                  Text("Normal:$normal", style: TextStyle(fontSize: 20)),
                  Text("Doctor: $doctor", style: TextStyle(fontSize: 20)),
                  Text("Place: $place", style: TextStyle(fontSize: 20)),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await _patientData.deleteAnyPatientRecord(
                                  patientId, recordId, "labtest");
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.deepPurple,
                          ),
                        ],
                      ))
                ]),
          ],
        ));
  }
}
