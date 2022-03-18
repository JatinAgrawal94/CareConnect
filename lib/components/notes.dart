import 'package:careconnect/components/photogrid.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class NotesList extends StatefulWidget {
  final String title;
  final String description;
  final String patientId;
  final String recordId;
  final dynamic media;
  NotesList(
      {Key key,
      this.title,
      this.description,
      this.patientId,
      this.recordId,
      this.media})
      : super(key: key);

  @override
  _NotesListState createState() => _NotesListState(
      this.title, this.description, this.patientId, this.recordId, this.media);
}

class _NotesListState extends State<NotesList> {
  final String title;
  final String description;
  final String patientId;
  final String recordId;
  final dynamic media;
  final PatientData _patientData = PatientData();

  _NotesListState(
      this.title, this.description, this.patientId, this.recordId, this.media);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("$title", style: TextStyle(fontSize: 20)),
                Text("$description", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              (media['images'].length == 0 &&
                      media['videos'].length == 0 &&
                      media['files'].length == 0)
                  ? Text("")
                  : (media['images'].length == 0 &&
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
                            children: [
                              Text(
                                "View",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_right,
                                color: Colors.white,
                                size: 20,
                              )
                            ],
                          )),
                        ),
              IconButton(
                onPressed: () async {
                  await _patientData.deleteAnyPatientRecord(
                      patientId, recordId, "notes");
                },
                icon: Icon(
                  Icons.delete,
                  size: 20,
                ),
                color: Colors.deepPurple,
              )
            ],
          )
        ],
      ),
    );
  }
}
