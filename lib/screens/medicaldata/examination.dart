import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/components/examinationList.dart';
import 'package:careconnect/components/loading.dart';
import 'package:careconnect/components/photogrid.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ExaminationScreen extends StatefulWidget {
  final String patientId;
  final String userId;
  ExaminationScreen({Key key, @required this.patientId, this.userId})
      : super(key: key);

  @override
  _ExaminationScreenState createState() =>
      _ExaminationScreenState(this.patientId, this.userId);
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final String patientId;
  final String userId;

  String category = "examination";
  _ExaminationScreenState(this.patientId, this.userId);
  PatientData _patientData = PatientData();
  DateTime selecteddate = DateTime.now();
  GeneralFunctions general = GeneralFunctions();
  String temperature = "";
  String weight = "";
  String height = "";
  String symptoms = "";
  String diagnosis = "";
  String notes = "";
  String doctor = "";
  String newDoctor;
  String place = "CareConnect";
  var otherDoctor = 0;
  List<String> data = ['Other'];
  List images = [];
  List videos = [];
  List files = [];
  var names = {'images': [], 'videos': [], 'files': []};
  var examinationList = [];
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

    general.getAllUser('doctor').then((value) => {
          value.forEach((item) {
            if (mounted) {
              setState(() {
                data.add(item['name']);
              });
            }
          })
        });

    _patientData.getCategoryData('examination', patientId).then((value) {
      value.forEach((item) => {
            if (mounted)
              {
                setState(() {
                  examinationList.add(item);
                })
              }
          });
      if (examinationList.length == 0) {
        if (mounted) {
          setState(() {
            empty = 0;
          });
        }
      }
    });
  }

  Future setData() async {
    var data = await _patientData.getCategoryData("examination", patientId);
    if (mounted) {
      setState(() {
        this.examinationList = data;
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
            title: Text('Examination'),
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
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Form(
                              key: formkey,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text("Temperature",
                                              style: TextStyle(fontSize: 20))),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: TextFormField(
                                            cursorColor: Colors.deepPurple,
                                            onChanged: (value) {
                                              if (mounted) {
                                                setState(() {
                                                  temperature = value;
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Field can't be empty";
                                              } else if (value.length > 3) {
                                                return "Invalid value";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .deepPurple))),
                                          )),
                                      Text(
                                        'C/F',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Row(children: <Widget>[
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text("Weight",
                                            style: TextStyle(fontSize: 20))),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: TextFormField(
                                          cursorColor: Colors.deepPurple,
                                          onChanged: (value) {
                                            if (mounted) {
                                              setState(() {
                                                weight = value;
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Field can't be empty";
                                            } else if (value.length > 3) {
                                              return "Invalid value";
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: Colors
                                                              .deepPurple))),
                                        )),
                                    Text(
                                      'Kg',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    )
                                  ]),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text("Height",
                                              style: TextStyle(fontSize: 20))),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: TextFormField(
                                            cursorColor: Colors.deepPurple,
                                            onChanged: (value) {
                                              if (mounted) {
                                                setState(() {
                                                  height = value;
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Field can't be empty";
                                              } else if (value.length > 3) {
                                                return "Invalid value";
                                              } else {
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .deepPurple))),
                                          )),
                                      Text(
                                        'CM',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text("Symptoms",
                                              style: TextStyle(fontSize: 20))),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: TextFormField(
                                            cursorColor: Colors.deepPurple,
                                            onChanged: (value) {
                                              if (mounted) {
                                                setState(() {
                                                  symptoms = value;
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
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .deepPurple))),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text("Diagnosis",
                                              style: TextStyle(fontSize: 20))),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: TextFormField(
                                            cursorColor: Colors.deepPurple,
                                            onChanged: (value) {
                                              if (mounted) {
                                                setState(() {
                                                  diagnosis = value;
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
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .deepPurple))),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text("Notes",
                                              style: TextStyle(fontSize: 20))),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: TextFormField(
                                            cursorColor: Colors.deepPurple,
                                            onChanged: (value) {
                                              if (mounted) {
                                                setState(() {
                                                  notes = value;
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
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .deepPurple))),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text("Doctor",
                                              style: TextStyle(fontSize: 20))),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: DropdownButtonFormField(
                                            hint: Text(
                                              "Select Doctor",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            items: data
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                  child: Text(value,
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                  value: value);
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != "Other") {
                                                if (mounted) {
                                                  setState(() {
                                                    doctor = value;
                                                    if (otherDoctor == 1) {
                                                      doctor = null;
                                                      otherDoctor = 0;
                                                    }
                                                  });
                                                }
                                              } else {
                                                if (mounted) {
                                                  setState(() {
                                                    otherDoctor = 1;
                                                  });
                                                }
                                              }
                                            },
                                            validator: (value) {
                                              if (doctor == null &&
                                                  otherDoctor == 0) {
                                                return "Select doctor";
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .deepPurple))),
                                          )),
                                    ],
                                  ),
                                  otherDoctor != 0
                                      ? Row(
                                          children: <Widget>[
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text("DoctorName",
                                                    style: TextStyle(
                                                        fontSize: 20))),
                                            Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5, 0, 5, 0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: TextFormField(
                                                  cursorColor:
                                                      Colors.deepPurple,
                                                  onChanged: (value) {
                                                    if (mounted) {
                                                      setState(() {
                                                        newDoctor = value;
                                                      });
                                                    }
                                                  },
                                                  validator: (value) {
                                                    if (value.isEmpty &&
                                                        otherDoctor != 0) {
                                                      return "Field can't be empty";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .deepPurple))),
                                                )),
                                          ],
                                        )
                                      : Container(height: 0, width: 0),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text("Place",
                                              style: TextStyle(fontSize: 20))),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: TextFormField(
                                            initialValue: place,
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
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .deepPurple))),
                                          )),
                                    ],
                                  ),
                                  Container(
                                      margin: EdgeInsets.all(5),
                                      child: Row(children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                                Icons.date_range_outlined,
                                                size: 30),
                                            onPressed: () {
                                              _setDate(context);
                                            }),
                                        Text(
                                          "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ])),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(
                                            Icons.camera_alt,
                                            size: 30,
                                          ),
                                          onPressed: () async {
                                            var result = await FilePicker
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
                                              for (var i = 0;
                                                  i < images.length;
                                                  i++) {
                                                names['images']
                                                    .add(images[i]['name']);
                                              }
                                            } else {
                                              print("Error");
                                            }
                                          }),
                                      IconButton(
                                          icon:
                                              Icon(Icons.video_call, size: 35),
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
                                              for (var i = 0;
                                                  i < videos.length;
                                                  i++) {
                                                names['videos']
                                                    .add(videos[i]['name']);
                                              }
                                            } else {
                                              print("Error");
                                            }
                                          }),
                                      IconButton(
                                          icon:
                                              Icon(Icons.attach_file, size: 32),
                                          onPressed: () async {
                                            final result = await FilePicker
                                                .platform
                                                .pickFiles(
                                                    allowMultiple: true,
                                                    type: FileType.custom,
                                                    allowedExtensions: ['pdf']);
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
                                              for (var i = 0;
                                                  i < files.length;
                                                  i++) {
                                                names['files']
                                                    .add(files[i]['name']);
                                              }
                                            } else {
                                              print("Error");
                                            }
                                          })
                                    ],
                                  ),
                                  Text(
                                    "Media files should be less than 5MB",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Row(
                                      mainAxisAlignment: images.length == 0 &&
                                              videos.length == 0 &&
                                              files.length == 0
                                          ? MainAxisAlignment.center
                                          : MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              if (formkey.currentState
                                                  .validate()) {
                                                Fluttertoast.showToast(
                                                    msg: "Data Saved",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.SNACKBAR,
                                                    backgroundColor:
                                                        Colors.grey,
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

                                                _patientData.addMedicalData(
                                                    patientId, 'examination', {
                                                  'temperature': temperature,
                                                  'weight': weight,
                                                  'height': height,
                                                  'symptoms': symptoms,
                                                  'diagnosis': diagnosis,
                                                  'notes': notes,
                                                  'doctor': otherDoctor == 0
                                                      ? doctor
                                                      : newDoctor,
                                                  'place': place,
                                                  'date':
                                                      "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                                  "media": data,
                                                  'approved':
                                                      (role == 'doctor' ||
                                                              role == 'admin')
                                                          ? 'true'
                                                          : 'false',
                                                });
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "Error",
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
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.deepPurple),
                                            child: Text("Save",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white))),
                                        images.length == 0 &&
                                                videos.length == 0 &&
                                                files.length == 0
                                            ? Text("")
                                            : RawMaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
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
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "View",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Icon(
                                                          Icons.arrow_right,
                                                          size: 20,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    )),
                                              )
                                      ])
                                ],
                              )))),
              examinationList.length == 0 && empty == 1 && role == null
                  ? LoadingHeart()
                  : empty == 0
                      ? EmptyRecord()
                      : Container(
                          child: RefreshIndicator(
                              onRefresh: setData,
                              color: Colors.deepPurple,
                              child: ListView.builder(
                                  itemCount: examinationList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ExaminationList(
                                      temperature: examinationList[index]
                                          ['temperature'],
                                      weight: examinationList[index]['weight'],
                                      height: examinationList[index]['height'],
                                      symptoms: examinationList[index]
                                          ['symptoms'],
                                      diagnosis: examinationList[index]
                                          ['diagnosis'],
                                      notes: examinationList[index]['notes'],
                                      doctor: examinationList[index]['doctor'],
                                      date: examinationList[index]['date'],
                                      place: examinationList[index]['place'],
                                      recordId: examinationList[index]
                                          ['documentid'],
                                      patientId: patientId,
                                      media: examinationList[index]['media'],
                                      role: role,
                                      approved: examinationList[index]
                                          ['approved'],
                                    );
                                  }))),
            ],
          ),
        ));
  }
}
