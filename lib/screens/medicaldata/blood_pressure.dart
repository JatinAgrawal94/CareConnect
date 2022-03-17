import 'package:careconnect/components/blood_pressure_list.dart';
import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BloodPressureScreen extends StatefulWidget {
  final String patientId;
  BloodPressureScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _BloodPressureScreenState createState() =>
      _BloodPressureScreenState(patientId);
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  final String patientId;
  String systolic = "";
  String diastolic = "";
  String pulse = "";
  var empty = 1;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  DateTime selecteddate = DateTime.now();
  TimeOfDay selectedtime = TimeOfDay.now();
  _BloodPressureScreenState(this.patientId);
  PatientData _patientData = PatientData();
  List bloodPressureList = [];
  @override
  void initState() {
    super.initState();
    _patientData.getCategoryData('bloodpressure', patientId).then((value) {
      value.forEach((item) => {
            setState(() {
              bloodPressureList.add(item);
            })
          });
      if (bloodPressureList.length == 0) {
        setState(() {
          empty = 0;
        });
      }
    });
  }

  Future setData() async {
    var data = await _patientData.getCategoryData("bloodpressure", patientId);
    setState(() {
      this.bloodPressureList = data;
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

  _setTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedtime,
        builder: (BuildContext context, child) {
          return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.white,
                  onPrimary: Colors.deepPurple[300],
                  surface: Colors.deepPurple,
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child);
        });
    if (picked != null) {
      setState(() {
        selectedtime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Blood Pressure'),
            backgroundColor: Colors.deepPurple,
            bottom: TabBar(
              indicatorColor: Colors.white,
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
                      key: formkey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextFormField(
                              cursorColor: Colors.deepPurple,
                              onChanged: (value) {
                                setState(() {
                                  systolic = value;
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Field can't be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  hintText: "systolic",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.deepPurple))),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextFormField(
                              cursorColor: Colors.deepPurple,
                              onChanged: (value) {
                                setState(() {
                                  diastolic = value;
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Field can't be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  hintText: "diastolic",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.deepPurple))),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextFormField(
                              cursorColor: Colors.deepPurple,
                              onChanged: (value) {
                                setState(() {
                                  pulse = value;
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Field can't be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  hintText: "pulse",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.deepPurple))),
                            ),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () {
                              _setDate(context);
                            },
                          ),
                          Text(
                              "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                              style: TextStyle(fontSize: 20)),
                          IconButton(
                              icon: Icon(Icons.timer_rounded),
                              onPressed: () {
                                _setTime(context);
                              }),
                          Text(
                              "${selectedtime.hour > 12 ? ((selectedtime.hour - 12).toString()) : (selectedtime.hour)}:${selectedtime.minute < 10 ? ("0${selectedtime.minute}") : (selectedtime.minute)}" +
                                  "  " +
                                  "${selectedtime.hour > 12 ? ("PM") : ("AM")}",
                              style: TextStyle(fontSize: 20))
                        ],
                      )),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.deepPurple),
                      onPressed: () async {
                        if (formkey.currentState.validate()) {
                          _patientData
                              .addMedicalData(patientId, "bloodpressure", {
                            'systolic': systolic,
                            "diastolic": diastolic,
                            "pulse": pulse,
                            'date':
                                "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                            'time':
                                "${selectedtime.hour > 12 ? ((selectedtime.hour - 12).toString()) : (selectedtime.hour)}:${selectedtime.minute < 10 ? ("0${selectedtime.minute}") : (selectedtime.minute)}" +
                                    "  " +
                                    "${selectedtime.hour > 12 ? ("PM") : ("AM")}",
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
                        } else {}
                      },
                      child: Text("Save", style: TextStyle(fontSize: 20)))
                ]),
              ),
              bloodPressureList.length == 0 && empty == 1
                  ? LoadingHeart()
                  : empty == 0
                      ? EmptyRecord()
                      : Container(
                          child: RefreshIndicator(
                              color: Colors.deepPurple,
                              onRefresh: setData,
                              child: ListView.builder(
                                itemCount: bloodPressureList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return BloodPressureList(
                                    systolic: bloodPressureList[index]
                                        ['systolic'],
                                    diastolic: bloodPressureList[index]
                                        ['diastolic'],
                                    pulse: bloodPressureList[index]['pulse'],
                                    date: bloodPressureList[index]['date'],
                                    time: bloodPressureList[index]['time'],
                                  );
                                },
                              )))
            ],
          ),
        ));
  }
}
