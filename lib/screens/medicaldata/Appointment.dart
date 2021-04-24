import 'package:flutter/material.dart';

class Appointment extends StatefulWidget {
  Appointment({Key key}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  String notes;
  String doctor;
  String place;
  int visitType;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              title: Text("Appointment"),
              bottom: TabBar(tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ])),
          body: TabBarView(children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.date_range),
                        Text("Pick a Date", style: TextStyle(fontSize: 20)),
                        Text("24/04/2021", style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.timer_sharp),
                        Text("1:50 PM", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Visit Type",
                          style: TextStyle(fontSize: 20),
                        ),
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
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Row(children: <Widget>[
                        Text(
                          "Notes",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                            width: MediaQuery.of(context).size.width * 0.7,
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
                      ])),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Row(children: <Widget>[
                        Text(
                          "Doctor",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                            width: MediaQuery.of(context).size.width * 0.7,
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
                      ])),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Row(children: <Widget>[
                        Text(
                          "Place",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                            width: MediaQuery.of(context).size.width * 0.7,
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
                      ])),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text("Save", style: TextStyle(fontSize: 20)))
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
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "24/04/2021",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "6:00 PM",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                    "Note:Covid Patient, stay at safe distance",
                                    style: TextStyle(fontSize: 14)),
                              )
                            ],
                          )
                        ],
                      )),
                ],
              ),
            )
          ]),
        ));
  }
}
