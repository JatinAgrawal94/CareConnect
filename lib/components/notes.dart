import 'package:flutter/material.dart';

class NotesList extends StatefulWidget {
  final String title;
  final String description;
  NotesList({Key key, this.title, this.description}) : super(key: key);

  @override
  _NotesListState createState() =>
      _NotesListState(this.title, this.description);
}

class _NotesListState extends State<NotesList> {
  final String title;
  final String description;
  _NotesListState(this.title, this.description);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
          )
        ],
      ),
    );
  }
}
