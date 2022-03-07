import 'package:careconnect/components/photogrid.dart';
import 'package:careconnect/components/radiology_list.dart';
import 'package:careconnect/services/doctorData.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:careconnect/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';

class RadiologyScreen extends StatefulWidget {
  final String patientId;
  final String userId;
  RadiologyScreen({Key key, @required this.patientId, this.userId})
      : super(key: key);

  @override
  _RadiologyScreenState createState() =>
      _RadiologyScreenState(patientId, this.userId);
}

class _RadiologyScreenState extends State<RadiologyScreen> {
  String category = "radiology";
  final String patientId;
  final String userId;
  String title;
  String result;
  String doctor;
  String place;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  _RadiologyScreenState(this.patientId, this.userId);
  DateTime selecteddate = DateTime.now();
  PatientData _patientData = PatientData();
  CollectionReference radiology;
  DoctorData _doctorData = DoctorData();
  List<String> data = [];
  List images = [];
  List videos = [];
  List files = [];
  var names = {'images': [], 'videos': [], 'files': []};

  @override
  void initState() {
    super.initState();
    _doctorData.getAllDoctors().then((value) => {
          value.forEach((item) {
            setState(() {
              data.add(item['name']);
            });
          })
        });
    setState(() {
      radiology =
          FirebaseFirestore.instance.collection('Patient/$patientId/radiology');
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
            title: Text('Radiology'),
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
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      child: Form(
                          key: formkey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5),
                                child: TextFormField(
                                  cursorColor: Colors.deepPurple,
                                  onChanged: (value) {
                                    setState(() {
                                      title = value;
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
                                      hintText: "Title",
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.deepPurple))),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: TextFormField(
                                  cursorColor: Colors.deepPurple,
                                  onChanged: (value) {
                                    setState(() {
                                      result = value;
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
                                      hintText: "Result",
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.deepPurple))),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  // width:MediaQuery.of(context).size.width * 0.5,
                                  child: Container(
                                      child: DropdownButtonFormField<String>(
                                    value: doctor,
                                    items: data.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                          child: Text(value,
                                              style: TextStyle(fontSize: 15)),
                                          value: value);
                                    }).toList(),
                                    hint: Text(
                                      "Select doctor",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        doctor = value;
                                      });
                                    },
                                    validator: (doctor) {
                                      if (doctor == null) {
                                        return "Field can't be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ))),
                              Container(
                                padding: EdgeInsets.all(5),
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
                                      hintText: "Place",
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.deepPurple))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.date_range, size: 30),
                                      onPressed: () {
                                        _setDate(context);
                                      },
                                    ),
                                    Text(
                                        "Date ${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                        style: TextStyle(fontSize: 20))
                                  ],
                                ),
                              ),
                              Container(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                    IconButton(
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: 30,
                                        ),
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
                                            for (var i = 0;
                                                i < files.length;
                                                i++) {
                                              names['files']
                                                  .add(files[i]['name']);
                                            }
                                          } else {
                                            print("Error");
                                          }
                                        }),
                                  ])),
                              Text(
                                "Media files should be less than 5MB",
                                style: TextStyle(fontSize: 15),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.deepPurple),
                                        onPressed: () async {
                                          if (formkey.currentState.validate()) {
                                            await _patientData
                                                .addRadiologyData(patientId, {
                                              'title': title,
                                              'result': result,
                                              'doctor': doctor,
                                              'place': place,
                                              'date':
                                                  "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                              "media": names
                                            });
                                            _patientData.uploadMediaFiles({
                                              'image': images,
                                              'video': videos,
                                              'file': files
                                            }, category, userId);
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
                                        )),
                                    RawMaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        PhotoGrid(
                                                            image: images,
                                                            video: videos,
                                                            file: files)));
                                      },
                                      fillColor: Colors.deepPurple,
                                      splashColor: Colors.white,
                                      child: Container(
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
                                ),
                              )
                            ],
                          )))),
              Container(
                  padding: EdgeInsets.all(5),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: radiology.snapshots(),
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
                          return RadiologyList(
                            title: document.data()['title'],
                            result: document.data()['result'],
                            doctor: document.data()['doctor'],
                            place: document.data()['place'],
                            date: document.data()['date'],
                            recordId: document.id,
                            patientId: patientId,
                          );
                        }).toList(),
                      );
                    },
                  )),
            ],
          ),
        ));
  }
}
