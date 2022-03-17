import 'package:careconnect/components/blood_glucose_List.dart';
import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BloodGlucoseScreen extends StatefulWidget {
  final String patientId;
  BloodGlucoseScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _BloodGlucoseScreenState createState() => _BloodGlucoseScreenState(patientId);
}

class _BloodGlucoseScreenState extends State<BloodGlucoseScreen> {
  final String patientId;
  _BloodGlucoseScreenState(this.patientId);
  PatientData _patientData = PatientData();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  int readingType = 0;
  DateTime selecteddate = DateTime.now();
  TimeOfDay selectedtime = TimeOfDay.now();
  String result = "";
  String resultUnit = 'mg/dL';
  List bloodGlucoseList = [];
  var empty = 1;

  @override
  void initState() {
    super.initState();
    _patientData.getCategoryData('bloodglucose', patientId).then((value) {
      value.forEach((item) => {
            setState(() {
              bloodGlucoseList.add(item);
            })
          });
      if (bloodGlucoseList.length == 0) {
        setState(() {
          empty = 0;
        });
      }
    });
  }

  Future setData() async {
    var data = await _patientData.getCategoryData("bloodglucose", patientId);
    setState(() {
      this.bloodGlucoseList = data;
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
            title: Text('Blood Glucose'),
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
              SingleChildScrollView(
                  child: Container(
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
                            activeColor: Colors.deepPurple,
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
                            activeColor: Colors.deepPurple,
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
                            activeColor: Colors.deepPurple,
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
                            key: formkey,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextFormField(
                                  cursorColor: Colors.deepPurple,
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
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.deepPurple)))),
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
                              resultUnit = value;
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
                            IconButton(
                              icon: Icon(Icons.date_range_outlined),
                              onPressed: () {
                                _setDate(context);
                              },
                            ),
                            Text(
                                "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}"
                                    .split(' ')[0],
                                style: TextStyle(fontSize: 18)),
                            IconButton(
                              icon: Icon(Icons.timer),
                              onPressed: () {
                                _setTime(context);
                              },
                            ),
                            Text(
                                "${selectedtime.hour > 12 ? ((selectedtime.hour - 12).toString()) : (selectedtime.hour)}:${selectedtime.minute < 10 ? ("0${selectedtime.minute}") : (selectedtime.minute)}" +
                                    "  " +
                                    "${selectedtime.hour > 12 ? ("PM") : ("AM")}",
                                style: TextStyle(fontSize: 18)),
                          ],
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple),
                        onPressed: () async {
                          if (formkey.currentState.validate()) {
                            _patientData
                                .addMedicalData(patientId, "bloodglucose", {
                              'type': readingType == 0
                                  ? 'Fasting'
                                  : readingType == 1
                                      ? "Postpradial"
                                      : "Random",
                              'result': result,
                              'resultUnit': resultUnit,
                              'date':
                                  "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                              'time':
                                  "${selectedtime.hour > 12 ? ((selectedtime.hour - 12).toString()) : (selectedtime.hour)}:${selectedtime.minute < 10 ? ("0${selectedtime.minute}") : (selectedtime.minute)}" +
                                      "  " +
                                      "${selectedtime.hour > 12 ? ("PM") : ("AM")}"
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
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
              )),
              bloodGlucoseList.length == 0 && empty == 1
                  ? LoadingHeart()
                  : empty == 0
                      ? EmptyRecord()
                      : Container(
                          child: RefreshIndicator(
                              color: Colors.deepPurple,
                              onRefresh: setData,
                              child: ListView.builder(
                                  itemCount: bloodGlucoseList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return BloodGlucoseList(
                                      type: bloodGlucoseList[index]['type'],
                                      result: bloodGlucoseList[index]['result'],
                                      date: bloodGlucoseList[index]['date'],
                                      time: bloodGlucoseList[index]['time'],
                                      resultUnit: bloodGlucoseList[index]
                                          ['resultUnit'],
                                      patientId: patientId,
                                      recordId: bloodGlucoseList[index]
                                          ['documentid'],
                                    );
                                  })))
            ],
          ),
        ));
  }
}
