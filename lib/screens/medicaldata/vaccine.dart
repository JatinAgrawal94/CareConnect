import 'package:flutter/material.dart';
// import 'package:careconnect/services/patientdata.dart';

class VaccineScreen extends StatefulWidget {
  final String patientId;
  VaccineScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _VaccineScreenState createState() => _VaccineScreenState(patientId);
}

class _VaccineScreenState extends State<VaccineScreen> {
  final String patientId;
  String vaccine;

  _VaccineScreenState(this.patientId);
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
            title: Text('Vaccine'),
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
                  child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Title",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Form(
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      vaccine = value;
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      InputDecoration(hintText: "Title"),
                                ),
                              )),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.date_range, size: 30),
                        Text("Date:24/04/2021", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 20),
                      ),
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
                        children: [
                          Text("Sputnik", style: TextStyle(fontSize: 20)),
                          Text("24/04/2021", style: TextStyle(fontSize: 16)),
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
