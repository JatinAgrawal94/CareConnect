import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class MedicalVisitScreen extends StatefulWidget {
  final String patientId;
  MedicalVisitScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _MedicalVisitScreenState createState() => _MedicalVisitScreenState(patientId);
}

class _MedicalVisitScreenState extends State<MedicalVisitScreen> {
  final String patientId;
  String date;
  int visitType;
  String doctor;
  String place;
  _MedicalVisitScreenState(this.patientId);
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
            title: Text('Medical Visit'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New Appointment')),
                Tab(child: Text('Previous Appointments')),
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
                          children: <Widget>[
                            Text("Date", style: TextStyle(fontSize: 20)),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Form(
                                    child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            date = value;
                                          });
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Enter date"))))
                          ],
                        ),
                      ),
                      Container(
                          child: Row(
                        children: <Widget>[
                          Text("Visit Type", style: TextStyle(fontSize: 20)),
                          Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                      value: 0,
                                      groupValue: visitType,
                                      onChanged: (value) {
                                        setState(() {
                                          visitType = value;
                                        });
                                      }),
                                  Text("New", style: TextStyle(fontSize: 20)),
                                  Radio(
                                      value: 1,
                                      groupValue: visitType,
                                      onChanged: (value) {
                                        setState(() {
                                          visitType = value;
                                        });
                                      }),
                                  Text("Follow Up",
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ))
                        ],
                      )),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text("Doctor", style: TextStyle(fontSize: 20)),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Form(
                                    child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            doctor = value;
                                          });
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Enter Doctor"))))
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text("Place", style: TextStyle(fontSize: 20)),
                            Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Form(
                                    child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            place = value;
                                          });
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Enter Place")))),
                            ElevatedButton(
                                onPressed: () {},
                                child: Text("Save",
                                    style: TextStyle(fontSize: 20))),
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
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.5)),
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("Visit-",
                                        style: TextStyle(fontSize: 20)),
                                    Text("New", style: TextStyle(fontSize: 20))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "23/04/2021",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
