import 'package:careconnect/components/photogrid.dart';
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
  final dynamic media;
  final String role;
  final String approved;
  LabTestList(
      {Key key,
      this.test,
      this.result,
      this.normal,
      this.place,
      this.date,
      this.doctor,
      this.patientId,
      this.recordId,
      this.media,
      this.role,
      this.approved})
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
      this.recordId,
      this.media,
      this.role,
      this.approved);
}

class _LabTestListState extends State<LabTestList> {
  final String test;
  final String result;
  final String normal;
  final String doctor;
  final String place;
  final String date;
  final String patientId;
  final dynamic media;
  final String recordId;
  final String role;
  final String approved;
  PatientData _patientData = PatientData();

  _LabTestListState(
      this.test,
      this.result,
      this.normal,
      this.place,
      this.date,
      this.doctor,
      this.patientId,
      this.recordId,
      this.media,
      this.role,
      this.approved);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.26,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          color: approved == 'false' ? Colors.grey[200] : Colors.white,
        ),
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
                        children: <Widget>[
                          (media['images'].length == 0 &&
                                  media['videos'].length == 0 &&
                                  media['files'].length == 0)
                              ? Text("")
                              : RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                PhotoGrid(
                                                  image: media['images'],
                                                  video: media['videos'],
                                                  file: media['files'],
                                                  filetype: "record",
                                                )));
                                  },
                                  fillColor: Colors.deepPurple,
                                  splashColor: Colors.white,
                                  child: Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:<Widget> [
                                      Text(
                                        "View",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.arrow_right,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    ],
                                  )),
                                ),
                          IconButton(
                            onPressed: () async {
                              await _patientData.deleteAnyPatientRecord(
                                  patientId, recordId, "labtest");
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
                                            patientId,
                                            recordId,
                                            'labtest',
                                            approved);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: approved == 'false'
                                              ? Colors.green
                                              : Colors.red),
                                      child: approved == 'false'
                                          ? Text("Verify")
                                          : Text("Unverify")))
                        ],
                      ))
                ]),
          ],
        ));
  }
}
