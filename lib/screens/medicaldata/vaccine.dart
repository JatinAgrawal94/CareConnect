import 'package:careconnect/components/vaccine_list.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:careconnect/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VaccineScreen extends StatefulWidget {
  final String patientId;
  VaccineScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _VaccineScreenState createState() => _VaccineScreenState(patientId);
}

class _VaccineScreenState extends State<VaccineScreen> {
  final String patientId;
  String vaccine;
  DateTime selecteddate = DateTime.now();
  _VaccineScreenState(this.patientId);
  PatientData _patientData = PatientData();
  CollectionReference vaccineList;

  @override
  void initState() {
    super.initState();
    setState(() {
      vaccineList =
          FirebaseFirestore.instance.collection('Patient/$patientId/vaccine');
    });
  }

  _setDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selecteddate, // Refer step 1
        firstDate: DateTime(1950),
        lastDate: DateTime(2030),
        builder: (BuildContext context, child) {
          return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  surface: Colors.deepPurple,
                  onSurface: Colors.deepPurple,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child);
        });
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
            title: Text('Vaccine'),
            backgroundColor: Colors.deepPurple,
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
                        IconButton(
                          icon: Icon(Icons.date_range, size: 30),
                          onPressed: () {
                            _setDate(context);
                          },
                        ),
                        Text(
                            "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.deepPurple),
                      onPressed: () async {
                        await _patientData.addVaccine(patientId, {
                          'vaccine': vaccine,
                          'date':
                              "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}"
                        });
                        Fluttertoast.showToast(
                            msg: "Data Saved",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.SNACKBAR,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 15,
                            timeInSecForIosWeb: 1);
                        Navigator.pop(context);
                      },
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: vaccineList.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingHeart();
                      }

                      return new ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return VaccineList(
                              vaccine: document.data()['vaccine'],
                              date: document.data()['date']);
                        }).toList(),
                      );
                    },
                  ))
            ],
          ),
        ));
  }
}
