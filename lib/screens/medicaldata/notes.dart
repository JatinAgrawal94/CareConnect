import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class NotesScreen extends StatefulWidget {
  final String patientId;
  NotesScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState(patientId);
}

class _NotesScreenState extends State<NotesScreen> {
  final String patientId;
  _NotesScreenState(this.patientId);
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
            title: Text('Notes'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text("New Notes")),
              Center(child: Text("Previous Notes"))
            ],
          ),
        ));
  }
}
