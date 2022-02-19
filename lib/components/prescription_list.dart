import 'package:flutter/material.dart';

class PrescriptionList extends StatefulWidget {
  final String drug;
  final String dose;
  final String doctor;

  PrescriptionList({Key key, this.drug, this.dose, this.doctor})
      : super(key: key);

  @override
  _PrescriptionListState createState() =>
      _PrescriptionListState(this.drug, this.dose, this.doctor);
}

class _PrescriptionListState extends State<PrescriptionList> {
  final String drug;
  final String dose;
  final String doctor;

  _PrescriptionListState(this.drug, this.dose, this.doctor);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$drug",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "$dose",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Doctor:$doctor",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          Column(children: <Widget>[
            Container(
              child: IconButton(
                iconSize: 50,
                color: Colors.deepPurple,
                icon: Icon(Icons.notification_add),
                onPressed: () {},
              ),
            )
          ])
        ],
      ),
    );
  }
}
