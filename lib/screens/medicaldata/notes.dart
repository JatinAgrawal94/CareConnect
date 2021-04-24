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
  String title;
  String notes;
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
              Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Form(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  title = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Title"),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: Form(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  notes = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Notes"),
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.camera_alt_rounded, size: 40),
                              Icon(Icons.video_call_outlined, size: 40),
                              Icon(Icons.attach_file_outlined, size: 40),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Text("Save",
                                      style: TextStyle(fontSize: 20))),
                            ]),
                      )
                    ],
                  )),
              Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.note_add_sharp,
                            size: 50,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Title", style: TextStyle(fontSize: 20)),
                                Text("24/04/2021",
                                    style: TextStyle(fontSize: 14)),
                                Text("Notes", style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
