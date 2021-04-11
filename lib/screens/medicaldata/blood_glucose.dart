import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class BloodGlucoseScreen extends StatefulWidget {
  final String patientId;
  BloodGlucoseScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _BloodGlucoseScreenState createState() => _BloodGlucoseScreenState(patientId);
}

class _BloodGlucoseScreenState extends State<BloodGlucoseScreen> {
  final String patientId;
  _BloodGlucoseScreenState(this.patientId);
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
            title: Text('Blood Glucose'),
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
