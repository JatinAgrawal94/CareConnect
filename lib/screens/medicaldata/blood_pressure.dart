import 'package:careconnect/components/blood_pressure_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:careconnect/services/patientdata.dart';

class BloodPressureScreen extends StatefulWidget {
  final String patientId;
  BloodPressureScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _BloodPressureScreenState createState() =>
      _BloodPressureScreenState(patientId);
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  final String patientId;
  String systolic;
  String diastolic;
  String pulse;
  _BloodPressureScreenState(this.patientId);
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
            title: Text('Blood Pressure'),
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
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Reading",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Form(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Form(
                          child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              systolic = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(hintText: "systolic"),
                        ),
                      )),
                      Form(
                          child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              diastolic = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(hintText: "diastolic"),
                        ),
                      )),
                      Form(
                          child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              pulse = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(hintText: "pulse"),
                        ),
                      ))
                    ],
                  )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(Icons.date_range),
                          Text("12/04/2021", style: TextStyle(fontSize: 20)),
                          Icon(Icons.timer_rounded),
                          Text("05:21 PM", style: TextStyle(fontSize: 20))
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text("Save", style: TextStyle(fontSize: 20)))
                ]),
              ),
              Container(
                child: Column(
                  children: <Widget>[BloodPressureList(), BloodPressureList()],
                ),
              )
            ],
          ),
        ));
  }
}
