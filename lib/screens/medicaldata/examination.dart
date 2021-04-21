import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class ExaminationScreen extends StatefulWidget {
  final String patientId;
  ExaminationScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _ExaminationScreenState createState() => _ExaminationScreenState(patientId);
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  final String patientId;
  _ExaminationScreenState(this.patientId);
  // PatientData _patientData = PatientData();
  String temperature;
  String weight;
  String height;
  String symptoms;
  String diagnosis;
  String notes;
  String doctor;
  String place;

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
            title: Text('Examination'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Temperature",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        temperature = value;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                  ))),
                              Text(
                                'C/F',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey[300]),
                              )
                            ],
                          ),
                          Row(children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text("Weight",
                                    style: TextStyle(fontSize: 20))),
                            Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Form(
                                    child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      weight = value;
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                ))),
                            Text(
                              'Kg',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            )
                          ]),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Height",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        height = value;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                  ))),
                              Text(
                                'cm',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey[300]),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Symptoms",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        symptoms = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                  ))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Diagnosis",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        diagnosis = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                  ))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Notes",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        notes = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                  ))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Doctor",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        doctor = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                  ))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Place",
                                      style: TextStyle(fontSize: 20))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Form(
                                      child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        place = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                  ))),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.all(5),
                              child: Row(children: <Widget>[
                                Icon(Icons.date_range_outlined, size: 30),
                                Text(
                                  ": 21-04-21",
                                  style: TextStyle(fontSize: 20),
                                )
                              ])),
                          Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),
                                  onPressed: () {}),
                              IconButton(
                                  icon: Icon(Icons.video_call, size: 30),
                                  onPressed: () {}),
                              IconButton(
                                  icon: Icon(Icons.attach_file, size: 30),
                                  onPressed: () {})
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue),
                              child: Text("Save",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white))),
                        ],
                      ))),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(5),
                          decoration:
                              BoxDecoration(border: Border.all(width: 0.5)),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.file_copy_sharp,
                                          size: 30, color: Colors.grey[300]),
                                      onPressed: () {}),
                                  Column(children: <Widget>[
                                    Text("Examination",
                                        style: TextStyle(fontSize: 20)),
                                    Text("12-04-21",
                                        style: TextStyle(fontSize: 20))
                                  ]),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.check_box_outline_blank_outlined),
                                  Text("Vital Signs",
                                      style: TextStyle(fontSize: 20))
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      Column(children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.circle),
                                            Text(
                                              "Temperature",
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ],
                                        ),
                                        Row(children: <Widget>[
                                          Icon(Icons.circle),
                                          Text("Weight: 2Kg",
                                              style: TextStyle(fontSize: 20))
                                        ]),
                                        Row(children: <Widget>[
                                          Icon(Icons.circle),
                                          Text("Height: 3cm",
                                              style: TextStyle(fontSize: 20))
                                        ])
                                      ]),
                                    ],
                                  )),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.check_box_outline_blank_outlined),
                                  Text("Symptoms",
                                      style: TextStyle(fontSize: 20))
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.circle),
                                      Text("Nausea",
                                          style: TextStyle(fontSize: 20))
                                    ],
                                  )),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.check_box_outline_blank_outlined),
                                  Text("Diagnosis",
                                      style: TextStyle(fontSize: 20))
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.circle),
                                      Text("Viral Infection",
                                          style: TextStyle(fontSize: 20))
                                    ],
                                  )),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.check_box_outline_blank_outlined),
                                  Text("Doctor", style: TextStyle(fontSize: 20))
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.circle),
                                      Text("Dr. Rakesh Mishra",
                                          style: TextStyle(fontSize: 20))
                                    ],
                                  )),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.check_box_outline_blank_outlined),
                                  Text("Place", style: TextStyle(fontSize: 20))
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.circle),
                                      Text("Vadodara",
                                          style: TextStyle(fontSize: 20))
                                    ],
                                  )),
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
