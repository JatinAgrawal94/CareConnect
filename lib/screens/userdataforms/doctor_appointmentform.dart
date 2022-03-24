import 'package:flutter/material.dart';
import 'package:careconnect/services/doctordata.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DoctorAppointmentForm extends StatefulWidget {
  final String doctorId;
  DoctorAppointmentForm({Key key, this.doctorId}) : super(key: key);

  @override
  State<DoctorAppointmentForm> createState() =>
      _DoctorAppointmentFormState(this.doctorId);
}

class _DoctorAppointmentFormState extends State<DoctorAppointmentForm> {
  String doctorId;
  _DoctorAppointmentFormState(this.doctorId);
  DateTime selecteddate = DateTime.now();
  TimeOfDay selectedtime1 = TimeOfDay.now();
  TimeOfDay selectedtime2 = TimeOfDay.now();
  String startTime;
  String endTime;
  String slot;
  DoctorData _doctorData = DoctorData();
  final GlobalKey<FormState> doctorappointmentkey = GlobalKey<FormState>();

  Future convertDate(String date) async {
    var g = date.split('/').reversed.toList();
    if (int.parse(g[1]) / 10 < 1) {
      g[1] = "0" + g[1];
    }

    if (int.parse(g[2]) / 10 < 1) {
      g[2] = "0" + g[2];
    }
    return g.join('-').toString();
  }

  @override
  void initState() {
    super.initState();
  }

  // date time slots-2 total patients to be taken
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

  Future _setTime(BuildContext context, TimeOfDay selectedtime) async {
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
      return picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    startTime =
        "${selectedtime1.hour > 12 ? ((selectedtime1.hour - 12).toString()) : (selectedtime1.hour)}:${selectedtime1.minute < 10 ? ("0${selectedtime1.minute}") : (selectedtime1.minute)}" +
            "  " +
            "${selectedtime1.hour > 12 ? ("PM") : ("AM")}";

    endTime =
        "${selectedtime2.hour > 12 ? ((selectedtime2.hour - 12).toString()) : (selectedtime2.hour)}:${selectedtime2.minute < 10 ? ("0${selectedtime2.minute}") : (selectedtime2.minute)}" +
            "  " +
            "${selectedtime2.hour > 12 ? ("PM") : ("AM")}";

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Appointment'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            child: Column(
              children: <Widget>[
                Form(
                    key: doctorappointmentkey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Date",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Text(
                                  "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}"),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple),
                                  onPressed: () {
                                    _setDate(context);
                                  },
                                  child: Text("Change"))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.timer_sharp),
                                onPressed: () async {
                                  setState(() async {
                                    selectedtime1 =
                                        await _setTime(context, selectedtime1);
                                  });
                                },
                              ),
                              Text(
                                  "${selectedtime1.hour > 12 ? ((selectedtime1.hour - 12).toString()) : (selectedtime1.hour)}:${selectedtime1.minute < 10 ? ("0${selectedtime1.minute}") : (selectedtime1.minute)}" +
                                      "${selectedtime1.hour > 12 ? ("PM") : ("AM")}",
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.timer_sharp),
                                onPressed: () async {
                                  setState(() async {
                                    selectedtime2 =
                                        await _setTime(context, selectedtime2);
                                  });
                                },
                              ),
                              Text(
                                  "${selectedtime2.hour > 12 ? ((selectedtime2.hour - 12).toString()) : (selectedtime2.hour)}:${selectedtime2.minute < 10 ? ("0${selectedtime2.minute}") : (selectedtime2.minute)}" +
                                      "${selectedtime2.hour > 12 ? ("PM") : ("AM")}",
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "No Of Patients",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 18),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
                                    cursorColor: Colors.deepPurple,
                                    onChanged: (val) {
                                      setState(() {
                                        slot = val;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.deepPurple))),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () async {
                                    // if (doctorappointmentkey.currentState
                                    //     .validate()) {
                                    //   await _doctorData
                                    //       .createDoctorAppointment(doctorId, {
                                    //     "date":
                                    //         "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                    //     "time": "$startTime-$endTime",
                                    //   });
                                    //   Fluttertoast.showToast(
                                    //       msg: "Data Saved",
                                    //       toastLength: Toast.LENGTH_LONG,
                                    //       gravity: ToastGravity.SNACKBAR,
                                    //       backgroundColor: Colors.grey,
                                    //       textColor: Colors.white,
                                    //       fontSize: 15,
                                    //       timeInSecForIosWeb: 1);
                                    //   Navigator.pop(context);
                                    // }
                                  },
                                  child: Text(
                                    "Add",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple))
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
