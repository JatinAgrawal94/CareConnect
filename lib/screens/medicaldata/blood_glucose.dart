import 'package:careconnect/components/blood_glucose_List.dart';
import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class BloodGlucoseScreen extends StatefulWidget {
  final String patientId;
  BloodGlucoseScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _BloodGlucoseScreenState createState() => _BloodGlucoseScreenState(patientId);
}

class _BloodGlucoseScreenState extends State<BloodGlucoseScreen> {
  final String patientId;
  _BloodGlucoseScreenState(this.patientId);
  // PatientData _patientData = PatientData();
  int readingType;
  String result;
  String resultUnit = 'mg/dL';
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
            title: Text('Blood Glucose'),
            bottom: TabBar(
              tabs: [
                Tab(child: Text('New Reading')),
                Tab(child: Text('Previous Reading')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text(
                        "Type",
                        style: TextStyle(fontSize: 18),
                      )
                    ]),
                    Row(
                      children: <Widget>[
                        Radio(
                            value: 0,
                            groupValue: readingType,
                            onChanged: (val) {
                              setState(() {
                                readingType = val;
                              });
                            }),
                        Text("Fasting", style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                            value: 1,
                            groupValue: readingType,
                            onChanged: (val) {
                              setState(() {
                                readingType = val;
                              });
                            }),
                        Text("Postpradial", style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                            value: 2,
                            groupValue: readingType,
                            onChanged: (val) {
                              setState(() {
                                readingType = val;
                              });
                            }),
                        Text("Random", style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Results", style: TextStyle(fontSize: 18))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Form(
                            child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Field can't be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  result = value;
                                });
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(width: 1)))),
                        )),
                        DropdownButton<String>(
                          value: resultUnit,
                          items: <String>['mg/dL', 'mmol/L']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              child:
                                  Text(value, style: TextStyle(fontSize: 18)),
                              value: value,
                            );
                          }).toList(),
                          hint: Text("Unit"),
                          onChanged: (String value) {
                            setState(() {
                              result = value;
                            });
                          },
                        )
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.date_range_outlined),
                            Text("21-04-21", style: TextStyle(fontSize: 18)),
                            Icon(Icons.timer),
                            Text("10:30 AM", style: TextStyle(fontSize: 18)),
                          ],
                        ))
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    BloodGlucoseList(
                        type: "Fasting",
                        result: "120 mg/dL",
                        date: "10-04-21",
                        time: "10:30 PM"),
                    BloodGlucoseList(
                        type: "Random",
                        result: "110 mg/dL",
                        date: "9-04-21",
                        time: "11:30 PM"),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
