import 'package:flutter/material.dart';

class PathologyList extends StatefulWidget {
  final String title;
  final String result;
  final String doctor;
  final String date;
  final String place;
  PathologyList(
      {Key key, this.title, this.result, this.doctor, this.date, this.place})
      : super(key: key);

  @override
  _PathologyListState createState() => _PathologyListState(
      this.title, this.result, this.doctor, this.date, this.place);
}

class _PathologyListState extends State<PathologyList> {
  final String title;
  final String result;
  final String doctor;
  final String date;
  final String place;
  _PathologyListState(
      this.title, this.result, this.doctor, this.date, this.place);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.2,
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
            )
          ],
        ));
  }
}
