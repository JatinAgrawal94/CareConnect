import 'package:careconnect/components/photogrid.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class ExaminationList extends StatefulWidget {
  final String temperature;
  final String weight;
  final String height;
  final String symptoms;
  final String diagnosis;
  final String notes;
  final String doctor;
  final String place;
  final String date;
  final String patientId;
  final String recordId;
  final dynamic media;
  final String approved;
  final String role;

  ExaminationList(
      {Key key,
      this.temperature,
      this.weight,
      this.height,
      this.symptoms,
      this.diagnosis,
      this.notes,
      this.doctor,
      this.date,
      this.place,
      this.patientId,
      this.recordId,
      this.media,
      this.approved,
      this.role})
      : super(key: key);

  @override
  _ExaminationListState createState() => _ExaminationListState(
      this.temperature,
      this.weight,
      this.height,
      this.symptoms,
      this.diagnosis,
      this.notes,
      this.doctor,
      this.date,
      this.place,
      this.patientId,
      this.recordId,
      this.media,
      this.approved,
      this.role);
}

class _ExaminationListState extends State<ExaminationList> {
  final String temperature;
  final String weight;
  final String height;
  final String symptoms;
  final String diagnosis;
  final String notes;
  final String doctor;
  final String place;
  final String date;
  final String patientId;
  final String recordId;
  final dynamic media;
  final String approved;
  final String role;
  final PatientData _patientData = PatientData();

  _ExaminationListState(
      this.temperature,
      this.weight,
      this.height,
      this.symptoms,
      this.diagnosis,
      this.notes,
      this.doctor,
      this.date,
      this.place,
      this.patientId,
      this.recordId,
      this.media,
      this.approved,
      this.role);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          color: approved == 'false' ? Colors.grey[200] : Colors.white,
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.file_copy_sharp,
                        size: 30, color: Colors.grey[300]),
                    onPressed: () {}),
                Column(children: <Widget>[
                  Text("Examination", style: TextStyle(fontSize: 20)),
                  Text("$date", style: TextStyle(fontSize: 20))
                ]),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.check_box_outline_blank_outlined),
                Text("Vital Signs", style: TextStyle(fontSize: 20))
              ],
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.circle),
                          Text(
                            "Temperature: $temperature",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      Row(children: <Widget>[
                        Icon(Icons.circle),
                        Text("Weight: $weight", style: TextStyle(fontSize: 20))
                      ]),
                      Row(children: <Widget>[
                        Icon(Icons.circle),
                        Text("Height: $height", style: TextStyle(fontSize: 20))
                      ])
                    ]),
                  ],
                )),
            Row(
              children: <Widget>[
                Icon(Icons.check_box_outline_blank_outlined),
                Text("Symptoms", style: TextStyle(fontSize: 20))
              ],
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.circle),
                    Text("$symptoms", style: TextStyle(fontSize: 20))
                  ],
                )),
            Row(
              children: <Widget>[
                Icon(Icons.check_box_outline_blank_outlined),
                Text("Diagnosis", style: TextStyle(fontSize: 20))
              ],
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.circle),
                    Text("$diagnosis", style: TextStyle(fontSize: 20))
                  ],
                )),
            Row(
              children: <Widget>[
                Icon(Icons.check_box_outline_blank_outlined),
                Text("Doctor", style: TextStyle(fontSize: 20))
              ],
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.circle),
                    Text("$doctor", style: TextStyle(fontSize: 20))
                  ],
                )),
            Row(
              children: <Widget>[
                Icon(Icons.check_box_outline_blank_outlined),
                Text("Place", style: TextStyle(fontSize: 20))
              ],
            ),
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.circle),
                    Text("$place", style: TextStyle(fontSize: 20))
                  ],
                )),
            Row(
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
                                  builder: (BuildContext context) => PhotoGrid(
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
                          children: [
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
                          patientId, recordId, "examination");
                    },
                    icon: Icon(Icons.delete),
                    color: Colors.deepPurple)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
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
                                  patientId, recordId, 'examination', approved);
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
          ],
        ));
  }
}
