import 'package:flutter/material.dart';

class VaccineList extends StatefulWidget {
  final String vaccine;
  final String date;
  VaccineList({Key key, this.vaccine, this.date}) : super(key: key);

  @override
  _VaccineListState createState() => _VaccineListState(this.vaccine, this.date);
}

class _VaccineListState extends State<VaccineList> {
  final String vaccine;
  final String date;
  _VaccineListState(this.vaccine, this.date);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$vaccine", style: TextStyle(fontSize: 20)),
          Text("$date", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
