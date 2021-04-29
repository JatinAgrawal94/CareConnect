import 'package:flutter/material.dart';

class LabTestList extends StatefulWidget {
  final String test;
  final String result;
  final String normal;
  final String doctor;
  final String place;
  final String date;
  LabTestList(
      {Key key,
      this.test,
      this.result,
      this.normal,
      this.place,
      this.date,
      this.doctor})
      : super(key: key);

  @override
  _LabTestListState createState() => _LabTestListState(
      this.test, this.result, this.normal, this.place, this.date, this.doctor);
}

class _LabTestListState extends State<LabTestList> {
  final String test;
  final String result;
  final String normal;
  final String doctor;
  final String place;
  final String date;

  _LabTestListState(
      this.test, this.result, this.normal, this.place, this.date, this.doctor);
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
              Text("$test", style: TextStyle(fontSize: 20))
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Result:$result", style: TextStyle(fontSize: 20)),
                Text("Normal:$normal", style: TextStyle(fontSize: 20))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Doctor: $doctor", style: TextStyle(fontSize: 20)),
                Text("Place: $place", style: TextStyle(fontSize: 20))
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
