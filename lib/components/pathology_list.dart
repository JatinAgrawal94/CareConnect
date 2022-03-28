import 'package:careconnect/components/photogrid.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class PathologyList extends StatefulWidget {
  final String title;
  final String result;
  final String doctor;
  final String date;
  final String place;
  final String patientId;
  final String recordId;
  final dynamic media;
  final String role;
  final String approved;
  PathologyList(
      {Key key,
      this.title,
      this.result,
      this.doctor,
      this.date,
      this.place,
      this.patientId,
      this.recordId,
      this.media,
      this.role,
      this.approved})
      : super(key: key);

  @override
  _PathologyListState createState() => _PathologyListState(
      this.title,
      this.result,
      this.doctor,
      this.date,
      this.place,
      this.patientId,
      this.recordId,
      this.media,
      this.role,
      this.approved);
}

class _PathologyListState extends State<PathologyList> {
  final String title;
  final String result;
  final String doctor;
  final String date;
  final String place;
  final String patientId;
  final String recordId;
  final dynamic media;
  final String role;
  final String approved;
  PatientData _patientData = PatientData();

  _PathologyListState(
      this.title,
      this.result,
      this.doctor,
      this.date,
      this.place,
      this.patientId,
      this.recordId,
      this.media,
      this.role,
      this.approved);
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          color: approved == 'false' ? Colors.grey[200] : Colors.white,
        ),
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
              children: [
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                            )
                          ],
                        )),
                      ),
                IconButton(
                    onPressed: () async {
                      await _patientData.deleteAnyPatientRecord(
                          patientId, recordId, "pathology");
                    },
                    icon: Icon(Icons.delete),
                    color: Colors.deepPurple),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
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
                                patientId, recordId, 'pathology', approved);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: approved == 'false'
                                  ? Colors.green
                                  : Colors.red),
                          child: approved == 'false'
                              ? Text("Verify")
                              : Text("Unverify")))
            ])
          ],
        ));
  }
}
