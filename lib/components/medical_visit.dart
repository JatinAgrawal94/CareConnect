import 'package:flutter/material.dart';

class MedicalVisitList extends StatefulWidget {
  final String visitType;
  final String doctor;
  final String place;
  final String date;

  MedicalVisitList(
      {Key key, this.visitType, this.doctor, this.place, this.date})
      : super(key: key);

  @override
  _MedicalVisitListState createState() => _MedicalVisitListState(
      this.visitType, this.doctor, this.place, this.date);
}

class _MedicalVisitListState extends State<MedicalVisitList> {
  final String visitType;
  final String doctor;
  final String place;
  final String date;

  _MedicalVisitListState(this.visitType, this.doctor, this.place, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      height: MediaQuery.of(context).size.height * 0.1,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("$visitType", style: TextStyle(fontSize: 20)),
                Text("$date", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("$doctor", style: TextStyle(fontSize: 20)),
                Text("$place", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
