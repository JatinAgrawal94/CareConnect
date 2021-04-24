import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class PrescriptionScreen extends StatefulWidget {
  final String patientId;
  PrescriptionScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState(patientId);
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final String patientId;
  String drug;
  String dose;
  String doctor;
  String place;
  _PrescriptionScreenState(this.patientId);
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
            title: Text('Prescription'),
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
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Form(
                              child: Container(
                            margin: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  drug = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(hintText: "Drug"),
                            ),
                          )),
                          Form(
                              child: Container(
                            margin: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  dose = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(hintText: "Dose"),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                "Doctor",
                                style: TextStyle(fontSize: 20),
                              )),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Form(
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    doctor = value;
                                  });
                                },
                                decoration: InputDecoration(hintText: "Doctor"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                "Place",
                                style: TextStyle(fontSize: 20),
                              )),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Form(
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    place = value;
                                  });
                                },
                                decoration: InputDecoration(hintText: "Place"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(Icons.camera_alt, size: 30),
                            Icon(Icons.video_call_rounded, size: 30),
                            Icon(Icons.attach_file_outlined, size: 30),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Save",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                "Paracetamol",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "1 Tab/Day",
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                          Column(children: <Widget>[
                            Text(
                              "Doctor: Tushar Verma",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Place: Vadodara",
                              style: TextStyle(fontSize: 14),
                            )
                          ])
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
