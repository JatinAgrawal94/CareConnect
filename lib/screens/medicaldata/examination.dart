import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class ExaminationScreen extends StatefulWidget {
  final String patientId;
  ExaminationScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _ExaminationScreenState createState() => _ExaminationScreenState(patientId);
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  final String patientId;
  _ExaminationScreenState(this.patientId);
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
            title: Text('Examination'),
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
