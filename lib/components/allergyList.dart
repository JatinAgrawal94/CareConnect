import 'package:flutter/material.dart';

class AllergyList extends StatelessWidget {
  final String type;
  final String date;
  const AllergyList({Key key, this.type, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: Colors.white, border: Border.all(width: 0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Type: $type",
                  style: TextStyle(fontSize: 18),
                ),
              ]),
          Text(
            "Date:$date",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
