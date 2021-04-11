import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class AllergyScreen extends StatefulWidget {
  final String patientId;
  AllergyScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _AllergyScreenState createState() => _AllergyScreenState(patientId);
}

class _AllergyScreenState extends State<AllergyScreen> {
  final String patientId;
  _AllergyScreenState(this.patientId);
  PatientData _patientData = PatientData();

  @override
  void initState() {
    _patientData.getAllergyData(this.patientId).then((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Allergy'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text("New Allergy Page")),
              Center(child: Text("Previous Allergy Page"))
            ],
          ),
        ));
  }
}
