import 'package:flutter/material.dart';

class EmptyDoctorList extends StatelessWidget {
  const EmptyDoctorList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Text("No Doctors Added",
                style: TextStyle(color: Colors.grey))));
  }
}
