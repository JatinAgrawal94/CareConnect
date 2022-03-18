import 'package:careconnect/components/photogrid.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class SurgeryList extends StatefulWidget {
  final String title;
  final String result;
  final String doctor;
  final String date;
  final String place;
  final String patientId;
  final String recordId;
  final dynamic media;
  SurgeryList({
    Key key,
    this.title,
    this.result,
    this.doctor,
    this.date,
    this.place,
    this.patientId,
    this.recordId,
    this.media,
  }) : super(key: key);

  @override
  _SurgeryListState createState() => _SurgeryListState(
        this.title,
        this.result,
        this.doctor,
        this.date,
        this.place,
        this.patientId,
        this.recordId,
        this.media,
      );
}

class _SurgeryListState extends State<SurgeryList> {
  final String title;
  final String result;
  final String doctor;
  final String date;
  final String place;
  final String patientId;
  final String recordId;
  final dynamic media;
  String category = "surgery";
  PatientData _patientData = PatientData();
  _SurgeryListState(this.title, this.result, this.doctor, this.date, this.place,
      this.patientId, this.recordId, this.media);

  @override
  void initState() {
    super.initState();
    // _patientData.getMediaURL(userId, category, files);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text("$title", style: TextStyle(fontSize: 20))
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Result:$result", style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Place:$place", style: TextStyle(fontSize: 20))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Doctor: $doctor", style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Date: $date", style: TextStyle(fontSize: 20)),
              ],
            ),
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
                        patientId, recordId, "surgery");
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.deepPurple,
                )
              ],
            )
          ],
        ));
  }
}
