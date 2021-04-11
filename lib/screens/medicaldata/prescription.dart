import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class PrescriptionScreen extends StatefulWidget {
  final String patientId;
  PrescriptionScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState(patientId);
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final String patientId;
  _PrescriptionScreenState(this.patientId);
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
            title: Text('Prescription'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text("New Prescription")),
              Center(child: Text("Previous Prescription"))
            ],
          ),
        ));
  }
}
