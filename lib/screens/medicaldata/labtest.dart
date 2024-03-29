import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/components/labtest_list.dart';
import 'package:careconnect/components/loading.dart';
import 'package:careconnect/components/photogrid.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class LabTestScreen extends StatefulWidget {
  final String patientId;
  final String userId;
  LabTestScreen({Key key, @required this.patientId, this.userId})
      : super(key: key);

  @override
  _LabTestScreenState createState() =>
      _LabTestScreenState(patientId, this.userId);
}

class _LabTestScreenState extends State<LabTestScreen> {
  String category = "labtest";
  final String patientId;
  final String userId;
  String test = '';
  String result = '';
  String normal = '';
  String doctor = '';
  String newDoctor;
  String place = 'CareConnect';
  List<String> data = ['Other'];
  List images = [];
  List videos = [];
  List files = [];
  var otherDoctor = 0;
  _LabTestScreenState(this.patientId, this.userId);
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  PatientData _patientData = PatientData();
  GeneralFunctions general = GeneralFunctions();
  DateTime selecteddate = DateTime.now();
  List labtestList = [];
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
    _patientData.getCategoryData('labtest', patientId).then((value) {
      value.forEach((item) => {
            if (mounted)
              {
                setState(() {
                  labtestList.add(item);
                })
              }
          });
      if (labtestList.length == 0) {
        if (mounted) {
          setState(() {
            empty = 0;
          });
        }
      }
    });
  }

  Future setData() async {
    var data = await _patientData.getCategoryData("labtest", patientId);
    if (mounted) {
      setState(() {
        this.labtestList = data;
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
            title: Text('LabTest'),
            backgroundColor: Colors.deepPurple,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('New Tests')),
                Tab(child: Text('Previous Tests')),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: TextFormField(
                                      cursorColor: Colors.deepPurple,
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            test = value;
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
                                          hintText: "Test",
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.deepPurple))),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: TextFormField(
                                      cursorColor: Colors.deepPurple,
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            result = value;
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
                                          hintText: "Result",
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.deepPurple))),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: TextFormField(
                                      cursorColor: Colors.deepPurple,
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            normal = value;
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
                                          hintText: "Normal",
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.deepPurple))),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text("Doctor",
                                            style: TextStyle(fontSize: 20))),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                style:
                                                    TextStyle(fontSize: 20))),
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
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: "Doctor Name",
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 1,
                                                              color: Colors
                                                                  .deepPurple))),
                                            )),
                                      ],
                                    )
                                  : Container(width: 0, height: 0),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Place",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 0, 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
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
                                            hintText: "Place",
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 30),
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                          icon:
                                              Icon(Icons.date_range, size: 30),
                                          onPressed: () {
                                            _setDate(context);
                                          }),
                                      Text(
                                          "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                          style: TextStyle(fontSize: 20)),
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
                                        icon: Icon(Icons.camera_alt, size: 30)),
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
                                        icon: Icon(Icons.attach_file, size: 32),
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
                                          } else {
                                            print("Error");
                                          }
                                        }),
                                  ],
                                ),
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
                                              patientId, 'labtest', {
                                            'test': test,
                                            'result': result,
                                            'normal': normal,
                                            'doctor': otherDoctor == 0
                                                ? doctor
                                                : newDoctor,
                                            'place': place,
                                            'date':
                                                "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                            "media": data,
                                            'approved': (role == 'doctor' ||
                                                    role == 'admin')
                                                ? 'true'
                                                : 'false',
                                          });
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
                                                          fontSize: 20,
                                                          color: Colors.white,
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
                                  ])
                            ],
                          )),
                    )),
              labtestList.length == 0 && empty == 1 && role == null
                  ? LoadingHeart()
                  : empty == 0
                      ? EmptyRecord()
                      : Container(
                          child: RefreshIndicator(
                              onRefresh: setData,
                              color: Colors.deepPurple,
                              child: ListView.builder(
                                  itemCount: labtestList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return LabTestList(
                                      test: labtestList[index]['test'],
                                      result: labtestList[index]['result'],
                                      normal: labtestList[index]['normal'],
                                      doctor: labtestList[index]['doctor'],
                                      place: labtestList[index]['place'],
                                      date: labtestList[index]['date'],
                                      patientId: patientId,
                                      recordId: labtestList[index]
                                          ['documentid'],
                                      media: labtestList[index]['media'],
                                      role: role,
                                      approved: labtestList[index]['approved'],
                                    );
                                  })))
            ],
          ),
        ));
  }
}
