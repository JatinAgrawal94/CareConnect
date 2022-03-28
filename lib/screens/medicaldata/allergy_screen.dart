import 'package:careconnect/components/allergyList.dart';
import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/components/loading.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/general.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

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
  GeneralFunctions general = GeneralFunctions();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  DateTime selecteddate = DateTime.now();
  String type = "";
  List allergyList = [];
  var role;
  AuthService auth = AuthService();
  var empty = 1;
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
    _patientData.getCategoryData('allergy', patientId).then((value) {
      value.forEach((item) {
        if (mounted) {
          setState(() {
            allergyList.add(item);
          });
        }
      });
      if (allergyList.length == 0) {
        if (mounted) {
          setState(() {
            empty = 0;
          });
        }
      }
    });
  }

  Future setData() async {
    var data = await _patientData.getCategoryData("allergy", patientId);
    if (mounted) {
      setState(() {
        this.allergyList = data;
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
            title: Text('Allergy'),
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
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.all(5),
                    child: Form(
                      key: formkey,
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
                            cursorColor: Colors.deepPurple,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  type = value;
                                });
                              }
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
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.deepPurple))),
                            keyboardType: TextInputType.text,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                      iconSize: 20,
                                      onPressed: () {
                                        _setDate(context);
                                      },
                                      icon: Icon(
                                        Icons.date_range,
                                        size: 30,
                                      )),
                                  Text(
                                    "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}"
                                        .split(' ')[0],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              )),
                          Container(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple),
                                onPressed: () async {
                                  if (formkey.currentState.validate()) {
                                    await _patientData
                                        .addMedicalData(patientId, "allergy", {
                                      'type': type,
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
                                  "Add",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ))),
// ----------------------------------------------------------------------------------------------------------
              allergyList.length == 0 && empty == 1 && role == null
                  ? LoadingHeart()
                  : empty == 0
                      ? EmptyRecord()
                      : Container(
                          child: RefreshIndicator(
                              color: Colors.deepPurple,
                              onRefresh: setData,
                              child: ListView.builder(
                                itemCount: allergyList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return AllergyList(
                                    role: role,
                                    approved: allergyList[index]['approved'],
                                    type: allergyList[index]['type'],
                                    date: allergyList[index]['date'],
                                    patientId: patientId,
                                    recordId: allergyList[index]['documentid'],
                                  );
                                },
                              ))),
            ],
          ),
        ));
  }
}
