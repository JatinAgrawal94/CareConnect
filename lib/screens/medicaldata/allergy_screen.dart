import 'package:careconnect/components/allergyList.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllergyScreen extends StatefulWidget {
  final String patientId;
  AllergyScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _AllergyScreenState createState() => _AllergyScreenState(patientId);
}

class _AllergyScreenState extends State<AllergyScreen> {
  final String patientId;
  _AllergyScreenState(this.patientId);
  PatientData _patientData = PatientData();
  DateTime selecteddate = DateTime.now();
  String type = "";

  @override
  void initState() {
    _patientData.getAllergyData(this.patientId).then((value) {});
    super.initState();
  }

  _setDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selecteddate, // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selecteddate)
      setState(() {
        selecteddate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Allergy'),
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
                  margin: EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.all(5),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Type",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              )),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                type = value;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Field can't be empty";
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1))),
                            keyboardType: TextInputType.text,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Date",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}"
                                        .split(' ')[0],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        _setDate(context);
                                      },
                                      child: Text(
                                        "Change",
                                        style: TextStyle(fontSize: 18),
                                      ))
                                ],
                              )),
                          Container(
                              alignment: Alignment.topLeft,
                              child: ElevatedButton(
                                onPressed: () {
                                  return Fluttertoast.showToast(
                                      msg: "Data Saved",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.SNACKBAR,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 15,
                                      timeInSecForIosWeb: 1);
                                },
                                child: Text(
                                  "Add",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ))),
              Container(
                child: Column(
                  children: <Widget>[
                    AllergyList(type: "Food Allergy", date: "12-4-21"),
                    AllergyList(type: "Drug Allergy", date: "9-4-21"),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
