import 'package:flutter/material.dart';

class BloodGlucoseList extends StatelessWidget {
  final String type;
  final String date;
  final String time;
  final String result;
  const BloodGlucoseList(
      {Key key, this.type, this.result, this.date, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration:
            BoxDecoration(color: Colors.white, border: Border.all(width: 0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("$result", style: TextStyle(fontSize: 18)),
                        Text("Type:$type", style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.date_range_outlined),
                        Text("$date", style: TextStyle(fontSize: 18)),
                        Icon(Icons.timer),
                        Text("$time", style: TextStyle(fontSize: 18))
                      ],
                    ),
                  ],
                )),
            IconButton(
                icon: Icon(Icons.delete, size: 40, color: Colors.grey[300]),
                onPressed: () {})
          ],
        ));
  }
}
