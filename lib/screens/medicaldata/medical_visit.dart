import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class MedicalVisitScreen extends StatefulWidget {
  final String patientId;
  MedicalVisitScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _MedicalVisitScreenState createState() => _MedicalVisitScreenState(patientId);
}

class _MedicalVisitScreenState extends State<MedicalVisitScreen> {
  final String patientId;
  _MedicalVisitScreenState(this.patientId);
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
            title: Text('Medical Visit'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New Appointment')),
                Tab(child: Text('Previous Appointments')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text("New Appointments")),
              Center(child: Text("Previous Appointments"))
            ],
          ),
        ));
  }
}
