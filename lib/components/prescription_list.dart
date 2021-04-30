import 'package:flutter/material.dart';

class PrescriptionList extends StatefulWidget {
  final String drug;
  final String dose;
  final String doctor;
  final String place;

  PrescriptionList({Key key, this.drug, this.dose, this.doctor, this.place})
      : super(key: key);

  @override
  _PrescriptionListState createState() =>
      _PrescriptionListState(this.drug, this.dose, this.doctor, this.place);
}

class _PrescriptionListState extends State<PrescriptionList> {
  final String drug;
  final String dose;
  final String doctor;
  final String place;

  _PrescriptionListState(this.drug, this.dose, this.doctor, this.place);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                "$drug",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "$dose",
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          Column(children: <Widget>[
            Text(
              "Doctor:$doctor",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              "Place: $place",
              style: TextStyle(fontSize: 14),
            )
          ])
        ],
      ),
    );
  }
}
