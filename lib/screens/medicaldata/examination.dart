import 'package:careconnect/components/examinationList.dart';
import 'package:careconnect/components/loading.dart';
import 'package:careconnect/components/photogrid.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

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
  CollectionReference examination;
  String temperature = "";
  String weight = "";
  String height = "";
  String symptoms = "";
  String diagnosis = "";
  String notes = "";
  String doctor = "";
  String place = "";
  List<String> data = [];
  List images = [];
  List videos = [];
  List files = [];
  var names = {'images': [], 'videos': [], 'files': []};

  @override
  void initState() {
    super.initState();
    general.getAllUser('doctor').then((value) => {
          value.forEach((item) {
            setState(() {
              data.add(item['name']);
            });
          })
        });
    setState(() {
      examination = FirebaseFirestore.instance
          .collection('Patient/$patientId/examination');
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
              SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Form(
                          key: formkey,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text("Temperature",
                                          style: TextStyle(fontSize: 20))),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (value) {
                                          setState(() {
                                            temperature = value;
                                          });
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
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
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
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text("Weight",
                                        style: TextStyle(fontSize: 20))),
                                Container(
                                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: TextFormField(
                                      cursorColor: Colors.deepPurple,
                                      onChanged: (value) {
                                        setState(() {
                                          weight = value;
                                        });
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
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.deepPurple))),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text("Height",
                                          style: TextStyle(fontSize: 20))),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (value) {
                                          setState(() {
                                            height = value;
                                          });
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
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text("Symptoms",
                                          style: TextStyle(fontSize: 20))),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (value) {
                                          setState(() {
                                            symptoms = value;
                                          });
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
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
                                      )),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text("Diagnosis",
                                          style: TextStyle(fontSize: 20))),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (value) {
                                          setState(() {
                                            diagnosis = value;
                                          });
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
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
                                      )),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text("Notes",
                                          style: TextStyle(fontSize: 20))),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (value) {
                                          setState(() {
                                            notes = value;
                                          });
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
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
                                      )),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text("Doctor",
                                          style: TextStyle(fontSize: 20))),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      width: MediaQuery.of(context).size.width *
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
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                              value: value);
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            doctor = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (doctor == null) {
                                            return "Select doctor";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
                                      )),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text("Place",
                                          style: TextStyle(fontSize: 20))),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (value) {
                                          setState(() {
                                            place = value;
                                          });
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
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.deepPurple))),
                                      )),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.all(5),
                                  child: Row(children: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.date_range_outlined,
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
                                        final result = await FilePicker.platform
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
                                      icon: Icon(Icons.video_call, size: 35),
                                      onPressed: () async {
                                        final result = await FilePicker.platform
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
                                      icon: Icon(Icons.attach_file, size: 32),
                                      onPressed: () async {
                                        final result = await FilePicker.platform
                                            .pickFiles(
                                                allowMultiple: true,
                                                type: FileType.custom,
                                                allowedExtensions: ['pdf']);
                                        if (result != null) {
                                          files = await _patientData
                                              .prepareFiles(result.paths);
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
                              ElevatedButton(
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

                                      _patientData.addMedicalData(
                                          patientId, 'examination', {
                                        'temperature': temperature,
                                        'weight': weight,
                                        'height': height,
                                        'symptoms': symptoms,
                                        'diagnosis': diagnosis,
                                        'notes': notes,
                                        'doctor': doctor,
                                        'place': place,
                                        'date':
                                            "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                        "media": data
                                      });
                                    } else {}
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple),
                                  child: Text("Save",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white))),
                              RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PhotoGrid(
                                                  image: images,
                                                  video: videos,
                                                  file: files,
                                                  filetype: "new")));
                                },
                                fillColor: Colors.deepPurple,
                                splashColor: Colors.white,
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "View",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.arrow_right,
                                          color: Colors.white,
                                        )
                                      ],
                                    )),
                              )
                            ],
                          )))),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: examination.snapshots(),
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
                        return ExaminationList(
                            temperature: document.data()['temperature'],
                            weight: document.data()['temperature'],
                            height: document.data()['height'],
                            symptoms: document.data()['symptoms'],
                            diagnosis: document.data()['diagnosis'],
                            notes: document.data()['notes'],
                            doctor: document.data()['doctor'],
                            date: document.data()['date'],
                            place: document.data()['place'],
                            recordId: document.id,
                            patientId: patientId,
                            media: document.data()['media']);
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
