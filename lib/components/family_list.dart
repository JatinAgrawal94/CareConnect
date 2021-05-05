import 'package:flutter/material.dart';

class FamilyList extends StatefulWidget {
  final String name;
  final String description;
  FamilyList({Key key, this.name, this.description}) : super(key: key);

  @override
  _FamilyListState createState() => _FamilyListState(name, description);
}

class _FamilyListState extends State<FamilyList> {
  String name;
  String description;
  _FamilyListState(this.name, this.description);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 0.5), color: Colors.white),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Name: $name", style: TextStyle(fontSize: 20)),
              Text("Description: $description", style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
