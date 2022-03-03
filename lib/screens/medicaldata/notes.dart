import 'package:careconnect/components/notes.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:careconnect/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesScreen extends StatefulWidget {
  final String patientId;
  NotesScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState(patientId);
}

class _NotesScreenState extends State<NotesScreen> {
  final String patientId;
  String title;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String description;
  _NotesScreenState(this.patientId);
  PatientData _patientData = PatientData();
  CollectionReference notes;

  @override
  void initState() {
    super.initState();
    setState(() {
      notes = FirebaseFirestore.instance.collection('Patient/$patientId/notes');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Notes'),
            backgroundColor: Colors.deepPurple,
            bottom: TabBar(
              indicatorColor: Colors.white,
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
                  child: Form(
                      key: formkey,
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Form(
                                child: TextFormField(
                                  cursorColor: Colors.deepPurple,
                                  onChanged: (value) {
                                    setState(() {
                                      title = value;
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Title",
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.deepPurple))),
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              child: Form(
                                child: TextFormField(
                                  cursorColor: Colors.deepPurple,
                                  onChanged: (value) {
                                    setState(() {
                                      description = value;
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Notes",
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.deepPurple))),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.all(5),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(Icons.camera_alt_rounded, size: 40),
                                  Icon(Icons.video_call_outlined, size: 40),
                                  Icon(Icons.attach_file_outlined, size: 40),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.deepPurple),
                                      onPressed: () async {
                                        if (formkey.currentState.validate()) {
                                          await _patientData.addNotes(
                                              patientId, {
                                            'title': title,
                                            'description': description
                                          });
                                          Fluttertoast.showToast(
                                              msg: "Data Saved",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.SNACKBAR,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 15,
                                              timeInSecForIosWeb: 1);
                                          Navigator.pop(context);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Error",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.SNACKBAR,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 15,
                                              timeInSecForIosWeb: 1);
                                        }
                                      },
                                      child: Text("Save",
                                          style: TextStyle(fontSize: 20))),
                                ]),
                          )
                        ],
                      ))),
              Container(
                  padding: EdgeInsets.all(5),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: notes.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingHeart();
                      }

                      return new ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return NotesList(
                              title: document.data()['title'],
                              description: document.data()['description']);
                        }).toList(),
                      );
                    },
                  )),
            ],
          ),
        ));
  }
}
