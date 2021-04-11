import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class RadiologyScreen extends StatefulWidget {
  final String patientId;
  RadiologyScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _RadiologyScreenState createState() => _RadiologyScreenState(patientId);
}

class _RadiologyScreenState extends State<RadiologyScreen> {
  final String patientId;
  _RadiologyScreenState(this.patientId);
  // PatientData _patientData = PatientData();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Radiology'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text("New Reports")),
              Center(child: Text("Previous Reports"))
            ],
          ),
        ));
  }
}
