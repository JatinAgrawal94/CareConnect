import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class VaccineScreen extends StatefulWidget {
  final String patientId;
  VaccineScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _VaccineScreenState createState() => _VaccineScreenState(patientId);
}

class _VaccineScreenState extends State<VaccineScreen> {
  final String patientId;
  _VaccineScreenState(this.patientId);
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
            title: Text('Vaccine'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text("New doze")),
              Center(child: Text("Previous vaccine doze"))
            ],
          ),
        ));
  }
}
