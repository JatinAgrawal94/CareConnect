import 'package:careconnect/components/family_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:careconnect/services/patientdata.dart';

class FamilyHistoryScreen extends StatefulWidget {
  final String patientId;
  FamilyHistoryScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _FamilyHistoryScreenState createState() =>
      _FamilyHistoryScreenState(patientId);
}

class _FamilyHistoryScreenState extends State<FamilyHistoryScreen> {
  final String patientId;
  _FamilyHistoryScreenState(this.patientId);
  // PatientData _patientData = PatientData();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String memberName;
    String description;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Family History'),
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
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.family_restroom, size: 30),
                        Text("Family Member History",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Form(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                memberName = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Family Member Name",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1))),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Form(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                description = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Description",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1))),
                          ),
                        )),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text("Save", style: TextStyle(fontSize: 20)))
                  ],
                ),
              ),
              Container(
                child: Column(children: <Widget>[
                  FamilyList(
                      name: "Rakesh Mishra", description: "Heart Diesease"),
                  FamilyList(
                      name: "Sharda Mishra", description: "Lungs Infection"),
                  FamilyList(name: "Rupali Mishra", description: "Cancer"),
                ]),
              )
            ],
          ),
        ));
  }
}
