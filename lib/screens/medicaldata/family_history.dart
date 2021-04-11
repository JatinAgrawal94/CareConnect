import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class FamilyHistoryScreen extends StatefulWidget {
  final String patientId;
  FamilyHistoryScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _FamilyHistoryScreenState createState() =>
      _FamilyHistoryScreenState(patientId);
}

class _FamilyHistoryScreenState extends State<FamilyHistoryScreen> {
  final String patientId;
  _FamilyHistoryScreenState(this.patientId);
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
            title: Text('Family History'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text("New Reading Page")),
              Center(child: Text("Previous Reading Page"))
            ],
          ),
        ));
  }
}
