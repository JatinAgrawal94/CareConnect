import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class SurgeryScreen extends StatefulWidget {
  final String patientId;
  SurgeryScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _SurgeryScreenState createState() => _SurgeryScreenState(patientId);
}

class _SurgeryScreenState extends State<SurgeryScreen> {
  final String patientId;
  _SurgeryScreenState(this.patientId);
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
            title: Text('Surgery'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text("New")),
              Center(child: Text("Previous"))
            ],
          ),
        ));
  }
}
