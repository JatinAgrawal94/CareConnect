import 'package:flutter/material.dart';

class BloodPressureList extends StatefulWidget {
  BloodPressureList({Key key}) : super(key: key);

  @override
  _BloodPressureListState createState() => _BloodPressureListState();
}

class _BloodPressureListState extends State<BloodPressureList> {
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
                Text("23/04/2021", style: TextStyle(fontSize: 20)),
                Text("5:41 PM", style: TextStyle(fontSize: 20))
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
                    Text("120", style: TextStyle(fontSize: 20)),
                    Text("80", style: TextStyle(fontSize: 20)),
                    Text("80", style: TextStyle(fontSize: 20)),
                  ],
                )
              ],
            ),
          ),
          Container(
              child: Icon(
            Icons.delete,
            size: 35,
          )),
        ],
      ),
    );
  }
}
