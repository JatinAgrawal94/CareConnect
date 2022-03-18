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
      this.media})
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
      this.media);
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
      this.media);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
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
            )
          ],
        ));
  }
}
