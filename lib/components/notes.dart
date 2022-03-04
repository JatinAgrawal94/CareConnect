import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class NotesList extends StatefulWidget {
  final String title;
  final String description;
  final String patientId;
  final String recordId;
  NotesList(
      {Key key, this.title, this.description, this.patientId, this.recordId})
      : super(key: key);

  @override
  _NotesListState createState() => _NotesListState(
      this.title, this.description, this.patientId, this.recordId);
}

class _NotesListState extends State<NotesList> {
  final String title;
  final String description;
  final String patientId;
  final String recordId;
  final PatientData _patientData = PatientData();

  _NotesListState(this.title, this.description, this.patientId, this.recordId);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            Icons.note_add_sharp,
            size: 50,
          ),
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
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  await _patientData.deleteAnyPatientRecord(
                      patientId, recordId, "notes");
                },
                icon: Icon(Icons.delete),
                color: Colors.deepPurple,
              )
            ],
          )
        ],
      ),
    );
  }
}
