import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class LabTestScreen extends StatefulWidget {
  final String patientId;
  LabTestScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _LabTestScreenState createState() => _LabTestScreenState(patientId);
}

class _LabTestScreenState extends State<LabTestScreen> {
  final String patientId;
  String test;
  String result;
  String normal;
  String doctor;
  String place;

  _LabTestScreenState(this.patientId);
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
            title: Text('LabTest'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New Tests')),
                Tab(child: Text('Previous Tests')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Form(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                test = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(hintText: "Test"),
                          ),
                        )),
                        Form(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                result = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(hintText: "Result"),
                          ),
                        )),
                        Form(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                normal = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(hintText: "Normal"),
                          ),
                        ))
                      ],
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Doctor",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Form(
                                child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  doctor = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Doctor"),
                            )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Place",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Form(
                                child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  place = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Place"),
                            )),
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 30),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.date_range, size: 30),
                            Text("23/04/2021", style: TextStyle(fontSize: 20)),
                          ],
                        )),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(Icons.camera_alt, size: 30),
                          Icon(Icons.video_call_rounded, size: 30),
                          Icon(Icons.attach_file_outlined, size: 30),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text("Save"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.5)),
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("Thyroid Test",
                                      style: TextStyle(fontSize: 20))
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Result:6.5",
                                    style: TextStyle(fontSize: 20)),
                                Text("Normal:Less than 7",
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Doctor: Dr Tushar Verma",
                                    style: TextStyle(fontSize: 20)),
                                Text("Place: Vadodara",
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Date: 23/04/2021",
                                    style: TextStyle(fontSize: 20)),
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
