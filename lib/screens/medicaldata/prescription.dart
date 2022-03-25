import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/components/photogrid.dart';
import 'package:careconnect/components/prescription_list.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:careconnect/components/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class PrescriptionScreen extends StatefulWidget {
  final String patientId;
  final String userId;
  PrescriptionScreen({Key key, @required this.patientId, this.userId})
      : super(key: key);

  @override
  _PrescriptionScreenState createState() =>
      _PrescriptionScreenState(patientId, this.userId);
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String category = "prescription";
  final String patientId;
  final String userId;
  String drug;
  String dose;
  String doctor;
  String place;
  int frequency = 0;
  int otherDoctor = 0;
  List<String> timings = [];
  TimeOfDay selectedtime = TimeOfDay.now();
  DateTime selecteddate = DateTime.now();
  List<String> data = ['Other'];
  _PrescriptionScreenState(this.patientId, this.userId);
  PatientData _patientData = PatientData();
  GeneralFunctions general = GeneralFunctions();
  List images = [];
  List videos = [];
  List files = [];
  List prescriptionList = [];
  var empty = 1;

  @override
  void initState() {
    super.initState();
    general.getAllUser('doctor').then((value) => {
          value.forEach((item) {
            if (mounted) {
              setState(() {
                data.add(item['name']);
              });
            }
          })
        });
    _patientData.getCategoryData('prescription', patientId).then((value) {
      value.forEach((item) {
        if (mounted) {
          setState(() {
            prescriptionList.add(item);
          });
        }
      });
      if (prescriptionList.length == 0) {
        if (mounted) {
          setState(() {
            empty = 0;
          });
        }
      }
    });
  }

  Future setData() async {
    var data = await _patientData.getCategoryData("prescription", patientId);
    if (mounted) {
      setState(() {
        this.prescriptionList = data;
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
      if (mounted) {
        setState(() {
          selectedtime = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Prescription'),
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
              data.length == 1
                  ? LoadingHeart()
                  : SingleChildScrollView(
                      child: Form(
                          key: formkey,
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (value) {
                                          if (mounted) {
                                            setState(() {
                                              drug = value;
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
                                        style: TextStyle(fontSize: 20),
                                        decoration: InputDecoration(
                                            hintText: "Drug",
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (value) {
                                          if (mounted) {
                                            setState(() {
                                              dose = value;
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
                                        style: TextStyle(fontSize: 20),
                                        decoration: InputDecoration(
                                            hintText: "Dose",
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: <Widget>[
                                    Text(
                                      "Doctor",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(15, 0, 0, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Container(
                                            child:
                                                DropdownButtonFormField<String>(
                                          value: doctor,
                                          items: data
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                                child: Text(value,
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                                value: value);
                                          }).toList(),
                                          hint: Text(
                                            "Select doctor",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          onChanged: (String value) {
                                            if (value != 'Other') {
                                              if (mounted) {
                                                setState(() {
                                                  doctor = value;
                                                  if (otherDoctor == 1) {
                                                    otherDoctor = 0;
                                                  }
                                                });
                                              }
                                            } else {
                                              if (mounted) {
                                                setState(() {
                                                  doctor = null;
                                                  otherDoctor = 1;
                                                });
                                              }
                                            }
                                          },
                                          validator: (doctor) {
                                            if (doctor == null) {
                                              return "Field can't be empty";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ))),
                                  ])),
                              otherDoctor != 0
                                  ? Container(
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: <Widget>[
                                        Text(
                                          "Doctor",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(15, 0, 5, 0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: TextFormField(
                                            cursorColor: Colors.deepPurple,
                                            onChanged: (value) {
                                              if (mounted) {
                                                setState(() {
                                                  doctor = value;
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Field can't be Empty";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Doctor Name",
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .deepPurple))),
                                          ),
                                        ),
                                      ]))
                                  : Container(width: 0, height: 0),
                              Container(
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: <Widget>[
                                    Text(
                                      "Place",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
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
                                        initialValue: "CareConnect",
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(fontSize: 20),
                                        decoration: InputDecoration(
                                            hintText: "Place",
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
                                      ),
                                    ),
                                  ])),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.date_range,
                                            color: Colors.deepPurple),
                                        onPressed: () {
                                          _setDate(context);
                                        },
                                      ),
                                      Text(
                                          "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.timer_rounded,
                                              color: Colors.deepPurple),
                                          onPressed: () {
                                            _setTime(context);
                                          }),
                                      Text(
                                          "${selectedtime.hour > 12 ? ((selectedtime.hour - 12).toString()) : (selectedtime.hour)}:${selectedtime.minute < 10 ? ("0${selectedtime.minute}") : (selectedtime.minute)}" +
                                              "  " +
                                              "${selectedtime.hour > 12 ? ("PM") : ("AM")}",
                                          style: TextStyle(fontSize: 20)),
                                      IconButton(
                                          onPressed: () {
                                            if (mounted) {
                                              setState(() {
                                                if (timings.length < 3) {
                                                  timings.add(
                                                      "${selectedtime.hour > 12 ? ((selectedtime.hour - 12).toString()) : (selectedtime.hour)}:${selectedtime.minute < 10 ? ("0${selectedtime.minute}") : (selectedtime.minute)}" +
                                                          "  " +
                                                          "${selectedtime.hour > 12 ? ("PM") : ("AM")}");
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: "Max 3 Reminders",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.SNACKBAR,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                      timeInSecForIosWeb: 1);
                                                }
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.add_circle,
                                              color: Colors.deepPurple))
                                    ],
                                  )),
                              Container(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      IconButton(
                                          onPressed: () async {
                                            final result = await FilePicker
                                                .platform
                                                .pickFiles(
                                                    allowMultiple: true,
                                                    type: FileType.custom,
                                                    allowedExtensions: [
                                                  'jpg',
                                                  'jpeg',
                                                  'png'
                                                ]);
                                            if (result != null) {
                                              images = await _patientData
                                                  .prepareFiles(result.paths);
                                              for (var j = 0;
                                                  j < result.paths.length;
                                                  j++) {
                                                var sizeInMb =
                                                    File(result.paths[j])
                                                            .lengthSync() /
                                                        (1024 * 1024);
                                                if (sizeInMb > 5) {
                                                  Fluttertoast.showToast(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      msg: "Cannot Upload " +
                                                          _patientData.getName(
                                                              File(result
                                                                      .paths[j])
                                                                  .toString()));
                                                  images.removeAt(j);
                                                }
                                              }
                                              if (mounted) {
                                                setState(() {
                                                  images.length;
                                                });
                                              }
                                            } else {
                                              print("Error");
                                            }
                                          },
                                          icon:
                                              Icon(Icons.camera_alt, size: 30)),
                                      IconButton(
                                          onPressed: () async {
                                            final result = await FilePicker
                                                .platform
                                                .pickFiles(
                                                    allowMultiple: true,
                                                    type: FileType.custom,
                                                    allowedExtensions: [
                                                  'mp4',
                                                  'avi',
                                                  'mkv'
                                                ]);
                                            if (result != null) {
                                              videos = await _patientData
                                                  .prepareFiles(result.paths);
                                              for (var j = 0;
                                                  j < result.paths.length;
                                                  j++) {
                                                var sizeInMb =
                                                    File(result.paths[j])
                                                            .lengthSync() /
                                                        (1024 * 1024);
                                                if (sizeInMb > 5) {
                                                  Fluttertoast.showToast(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      msg: "Cannot Upload " +
                                                          _patientData.getName(
                                                              File(result
                                                                      .paths[j])
                                                                  .toString()));
                                                  videos.removeAt(j);
                                                }
                                              }
                                              if (mounted) {
                                                setState(() {
                                                  videos.length;
                                                });
                                              }
                                            } else {
                                              print("Error");
                                            }
                                          },
                                          icon: Icon(Icons.video_call_rounded,
                                              size: 35)),
                                      IconButton(
                                          icon:
                                              Icon(Icons.attach_file, size: 32),
                                          onPressed: () async {
                                            final result = await FilePicker
                                                .platform
                                                .pickFiles(
                                                    allowMultiple: true,
                                                    type: FileType.custom,
                                                    allowedExtensions: [
                                                  'pdf',
                                                ]);
                                            if (result != null) {
                                              files = await _patientData
                                                  .prepareFiles(result.paths);
                                              for (var j = 0;
                                                  j < result.paths.length;
                                                  j++) {
                                                var sizeInMb =
                                                    File(result.paths[j])
                                                            .lengthSync() /
                                                        (1024 * 1024);
                                                if (sizeInMb > 5) {
                                                  Fluttertoast.showToast(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      msg: "Cannot Upload " +
                                                          _patientData.getName(
                                                              File(result
                                                                      .paths[j])
                                                                  .toString()));
                                                  files.removeAt(j);
                                                }
                                              }
                                              if (mounted) {
                                                setState(() {
                                                  files.length;
                                                });
                                              }
                                            } else {
                                              print("Error");
                                            }
                                          }),
                                    ]),
                              ),
                              Text(
                                "Media files should be less than 5MB",
                                style: TextStyle(fontSize: 15),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: images.length == 0 &&
                                          videos.length == 0 &&
                                          files.length == 0
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.deepPurple),
                                      onPressed: () async {
                                        if (formkey.currentState.validate()) {
                                          Fluttertoast.showToast(
                                              msg: "Data Saved",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.SNACKBAR,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 15,
                                              timeInSecForIosWeb: 1);
                                          Navigator.pop(context);
                                          var data = await _patientData
                                              .uploadMediaFiles({
                                            'image': images,
                                            'video': videos,
                                            'file': files
                                          }, category, userId);
                                          await _patientData.addMedicalData(
                                              patientId, 'prescription', {
                                            'drug': drug,
                                            'dose': dose,
                                            'doctor': doctor,
                                            'place': place,
                                            'date':
                                                "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                            'timings': timings,
                                            'media': data
                                          });
                                        } else {}
                                      },
                                      child: Text(
                                        "Save",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    images.length == 0 &&
                                            videos.length == 0 &&
                                            files.length == 0
                                        ? Text("")
                                        : RawMaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          PhotoGrid(
                                                              image: images,
                                                              video: videos,
                                                              file: files,
                                                              filetype:
                                                                  "new")));
                                            },
                                            fillColor: Colors.deepPurple,
                                            splashColor: Colors.white,
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "View",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_right,
                                                      size: 20,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                )),
                                          )
                                  ],
                                ),
                              ),
                              Container(
                                // height: MediaQuery.of(context).size.height * 0.3,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: timings.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 0, 0),
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1)),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(timings[index],
                                                    style: TextStyle(
                                                        fontSize: 20))),
                                            IconButton(
                                                onPressed: () {
                                                  if (mounted) {
                                                    setState(() {
                                                      timings.removeAt(index);
                                                    });
                                                  }
                                                },
                                                icon: Icon(Icons.remove_circle))
                                          ],
                                        ));
                                  },
                                ),
                              )
                            ],
                          ))),
                    ),
              prescriptionList.length == 0 && empty == 1
                  ? LoadingHeart()
                  : empty == 0
                      ? EmptyRecord()
                      : Container(
                          child: RefreshIndicator(
                              onRefresh: setData,
                              color: Colors.deepPurple,
                              child: ListView.builder(
                                  itemCount: prescriptionList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PrescriptionList(
                                        drug: prescriptionList[index]['drug'],
                                        dose: prescriptionList[index]['dose'],
                                        doctor: prescriptionList[index]
                                            ['doctor'],
                                        date: prescriptionList[index]['date'],
                                        timing: prescriptionList[index]
                                            ['timings'],
                                        patientId: patientId,
                                        prescriptionId: prescriptionList[index]
                                            ['documentid'],
                                        media: prescriptionList[index]
                                            ['media']);
                                  })))
            ],
          ),
        ));
  }
}
