import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class BloodGlucoseList extends StatelessWidget {
  final String type;
  final String date;
  final String time;
  final String result;
  final String resultUnit;
  final String patientId;
  final String recordId;

  BloodGlucoseList(
      {Key key,
      this.type,
      this.result,
      this.date,
      this.time,
      this.resultUnit,
      this.patientId,
      this.recordId})
      : super(key: key);
  PatientData _patientData = PatientData();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration:
            BoxDecoration(color: Colors.white, border: Border.all(width: 0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("$result $resultUnit",
                          style: TextStyle(fontSize: 18)),
                      Text("$date", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Type:$type", style: TextStyle(fontSize: 18)),
                      Text("$time", style: TextStyle(fontSize: 18))
                    ],
                  ),
                  Column(children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        await _patientData.deleteAnyPatientRecord(
                            patientId, recordId, "bloodglucose");
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.deepPurple,
                    )
                  ])
                ],
              ),
            ),
          ],
        ));
  }
}
