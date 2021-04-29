import 'package:flutter/material.dart';

class BloodPressureList extends StatefulWidget {
  final String systolic;
  final String diastolic;
  final String pulse;
  final String date;
  final String time;
  BloodPressureList(
      {Key key,
      this.systolic,
      this.diastolic,
      this.pulse,
      this.date,
      this.time})
      : super(key: key);

  @override
  _BloodPressureListState createState() => _BloodPressureListState(
      this.systolic, this.diastolic, this.pulse, this.date, this.time);
}

class _BloodPressureListState extends State<BloodPressureList> {
  final String systolic;
  final String diastolic;
  final String pulse;
  final String date;
  final String time;
  _BloodPressureListState(
      this.systolic, this.diastolic, this.pulse, this.date, this.time);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      height: MediaQuery.of(context).size.height * 0.1,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("$date", style: TextStyle(fontSize: 20)),
                Text("$time", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Reading", style: TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("$systolic", style: TextStyle(fontSize: 20)),
                    Text("$diastolic", style: TextStyle(fontSize: 20)),
                    Text("$pulse", style: TextStyle(fontSize: 20)),
                  ],
                )
              ],
            ),
          ),
          Container(
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    size: 35,
                  ))),
        ],
      ),
    );
  }
}
