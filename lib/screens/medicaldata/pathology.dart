import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class PathologyScreen extends StatefulWidget {
  final String patientId;
  PathologyScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _PathologyScreenState createState() => _PathologyScreenState(patientId);
}

class _PathologyScreenState extends State<PathologyScreen> {
  final String patientId;
  _PathologyScreenState(this.patientId);
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
            title: Text('Pathology'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text("New Reports")),
              Center(child: Text("Previous Reports"))
            ],
          ),
        ));
  }
}
