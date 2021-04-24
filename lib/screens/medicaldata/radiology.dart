import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class RadiologyScreen extends StatefulWidget {
  final String patientId;
  RadiologyScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _RadiologyScreenState createState() => _RadiologyScreenState(patientId);
}

class _RadiologyScreenState extends State<RadiologyScreen> {
  final String patientId;
  String title;
  String result;
  String doctor;
  String place;
  _RadiologyScreenState(this.patientId);
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
            title: Text('Radiology'),
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
                          child: Form(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  result = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Result"),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Form(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  doctor = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Doctor"),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Form(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  place = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Place"),
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.date_range, size: 30),
                            Text("Date:24/04/2021",
                                style: TextStyle(fontSize: 20))
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(Icons.camera_alt, size: 30),
                            Icon(Icons.video_call, size: 30),
                            Icon(Icons.attach_file, size: 30),
                            ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Save",
                                  style: TextStyle(fontSize: 20),
                                ))
                          ],
                        ),
                      )
                    ],
                  )),
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
                                "Endoscopy",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "24/04/2021",
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
