import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class BloodPressureScreen extends StatefulWidget {
  final String patientId;
  BloodPressureScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _BloodPressureScreenState createState() =>
      _BloodPressureScreenState(patientId);
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  final String patientId;
  _BloodPressureScreenState(this.patientId);
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
            title: Text('Blood Pressure'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New Reading')),
                Tab(child: Text('Previous Reading')),
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
