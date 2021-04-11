import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class LabTestScreen extends StatefulWidget {
  final String patientId;
  LabTestScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _LabTestScreenState createState() => _LabTestScreenState(patientId);
}

class _LabTestScreenState extends State<LabTestScreen> {
  final String patientId;
  _LabTestScreenState(this.patientId);
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
            title: Text('LabTest'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New Tests')),
                Tab(child: Text('Previous Tests')),
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
