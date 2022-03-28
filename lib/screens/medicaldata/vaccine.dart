import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/components/vaccine_list.dart';
import 'package:careconnect/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:careconnect/components/loading.dart';
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
  String place;
  DateTime selecteddate = DateTime.now();
  _VaccineScreenState(this.patientId);
  PatientData _patientData = PatientData();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  List vaccineList = [];
  var empty = 1;
  var role;
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    auth.getRoleFromStorage().then((value) {
      if (mounted) {
        setState(() {
          role = value['role'];
        });
      }
    });
    _patientData.getCategoryData('vaccine', patientId).then((value) {
      value.forEach((item) {
        if (mounted) {
          setState(() {
            vaccineList.add(item);
          });
        }
      });
      if (vaccineList.length == 0) {
        if (mounted) {
          setState(() {
            empty = 0;
          });
        }
      }
    });
  }

  Future setData() async {
    var data = await _patientData.getCategoryData("vaccine", patientId);
    if (mounted) {
      setState(() {
        this.vaccineList = data;
      });
    }
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
    if (picked != null && picked != selecteddate) if (mounted) {
      setState(() {
        selecteddate = picked;
      });
    }
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
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('New')),
                Tab(child: Text('Previous')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                  child: Form(
                      key: formkey,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: TextFormField(
                                      cursorColor: Colors.deepPurple,
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            vaccine = value;
                                          });
                                        }
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Field can't be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          hintText: "Title",
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.deepPurple))),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Place",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: TextFormField(
                                      cursorColor: Colors.deepPurple,
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            place = value;
                                          });
                                        }
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Field can't be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          hintText: "Place",
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.deepPurple))),
                                    ),
                                  ),
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
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple),
                              onPressed: () async {
                                if (formkey.currentState.validate()) {
                                  await _patientData
                                      .addMedicalData(patientId, "vaccine", {
                                    'vaccine': vaccine,
                                    'place': place,
                                    'date':
                                        "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                    'approved':
                                        (role == 'doctor' || role == 'admin')
                                            ? 'true'
                                            : 'false',
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
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Error",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.SNACKBAR,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 15,
                                      timeInSecForIosWeb: 1);
                                }
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ))),
              vaccineList.length == 0 && empty == 1 && role == null
                  ? LoadingHeart()
                  : empty == 0
                      ? EmptyRecord()
                      : Container(
                          padding: EdgeInsets.all(5),
                          child: RefreshIndicator(
                              onRefresh: setData,
                              color: Colors.deepPurple,
                              child: ListView.builder(
                                  itemCount: vaccineList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return VaccineList(
                                      role: role,
                                      approved: vaccineList[index]['approved'],
                                      vaccine: vaccineList[index]['vaccine'],
                                      date: vaccineList[index]['date'],
                                      patientId: patientId,
                                      recordId: vaccineList[index]
                                          ['documentid'],
                                    );
                                  })))
            ],
          ),
        ));
  }
}
