import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/components/photogrid.dart';
import 'package:careconnect/components/surgery_list.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:careconnect/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';

class SurgeryScreen extends StatefulWidget {
  final String patientId;
  final String userId;
  SurgeryScreen({Key key, @required this.patientId, this.userId})
      : super(key: key);

  @override
  _SurgeryScreenState createState() =>
      _SurgeryScreenState(patientId, this.userId);
}

class _SurgeryScreenState extends State<SurgeryScreen> {
  String category = "surgery";
  final String userId;
  final String patientId;
  String title;
  String result;
  String doctor;
  String place;
  _SurgeryScreenState(this.patientId, this.userId);
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  PatientData _patientData = PatientData();
  GeneralFunctions general = GeneralFunctions();
  DateTime selecteddate = DateTime.now();
  CollectionReference surgery;
  List<String> data = [];
  List images = [];
  List videos = [];
  List files = [];
  List surgeryList = [];
  var empty = 1;
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
    _patientData.getCategoryData('surgery', patientId).then((value) {
      value.forEach((item) {
        setState(() {
          surgeryList.add(item);
        });
      });
      if (surgeryList.length == 0) {
        setState(() {
          empty = 0;
        });
      }
    });
  }

  Future setData() async {
    var data = await _patientData.getCategoryData("surgery", patientId);
    setState(() {
      this.surgeryList = data;
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
            title: Text('Surgery'),
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
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.date_range, size: 30),
                                      onPressed: () {
                                        _setDate(context);
                                      },
                                    ),
                                    Text(
                                        "Date: ${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
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
                                                i++) {}
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
                                            for (var i = 0;
                                                i < videos.length;
                                                i++) {}
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
                                                  allowedExtensions: [
                                                'pdf',
                                              ]);
                                          if (result != null) {
                                            files = await _patientData
                                                .prepareFiles(result.paths);
                                            for (var i = 0;
                                                i < files.length;
                                                i++) {}
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
                                          patientId, 'surgery', {
                                        'title': title,
                                        'result': result,
                                        'doctor': doctor,
                                        'place': place,
                                        'date':
                                            "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                        'media': data
                                      });
                                    } else {}
                                  },
                                  child: Text(
                                    "Save",
                                    style: TextStyle(fontSize: 20),
                                  )),
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
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
              surgeryList.length == 0 && empty == 1
                  ? LoadingHeart()
                  : empty == 0
                      ? EmptyRecord()
                      : Container(
                          padding: EdgeInsets.all(5),
                          child: RefreshIndicator(
                              onRefresh: setData,
                              color: Colors.deepPurple,
                              child: ListView.builder(
                                  itemCount: surgeryList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SurgeryList(
                                        title: surgeryList[index]['title'],
                                        result: surgeryList[index]['result'],
                                        doctor: surgeryList[index]['doctor'],
                                        place: surgeryList[index]['place'],
                                        date: surgeryList[index]['date'],
                                        patientId: patientId,
                                        recordId: surgeryList[index]
                                            ['documentid'],
                                        media: surgeryList[index]['media']);
                                  })))
            ],
          ),
        ));
  }
}
