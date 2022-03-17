import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/components/pathology_list.dart';
import 'package:careconnect/components/photogrid.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:careconnect/components/loading.dart';
import 'package:file_picker/file_picker.dart';

class PathologyScreen extends StatefulWidget {
  final String patientId;
  final String userId;
  PathologyScreen({Key key, @required this.patientId, this.userId})
      : super(key: key);

  @override
  _PathologyScreenState createState() =>
      _PathologyScreenState(patientId, this.userId);
}

// Medical Visit feature is for outside appointments outside careconnect which need to be entered by patient
// and later approved by doctor

class _PathologyScreenState extends State<PathologyScreen> {
  String category = "pathology";
  final String patientId;
  final String userId;
  String title = "";
  String result = "";
  String doctor;
  String place = "";
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  _PathologyScreenState(this.patientId, this.userId);
  PatientData _patientData = PatientData();
  DateTime selecteddate = DateTime.now();
  GeneralFunctions general = GeneralFunctions();
  List<String> data = [];
  List images = [];
  List videos = [];
  List files = [];
  List pathologyList = [];
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
    _patientData.getCategoryData('pathology', patientId).then((value) {
      value.forEach((item) {
        setState(() {
          pathologyList.add(item);
        });
      });
      if (pathologyList.length == 0) {
        setState(() {
          empty = 0;
        });
      }
    });
  }

  Future setData() async {
    var data = await _patientData.getCategoryData("pathology", patientId);
    setState(() {
      this.pathologyList = data;
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
            title: Text('Pathology'),
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
                child: Form(
                    key: formkey,
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Title",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Result",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Doctor",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
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
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Field can't be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ))),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Place",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                              ],
                            )),
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
                                  "Date : ${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                  style: TextStyle(fontSize: 20))
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
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
                                    } else {
                                      print("Error");
                                    }
                                  },
                                  icon: Icon(Icons.camera_alt, size: 30)),
                              IconButton(
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
                                    } else {
                                      print("Error");
                                    }
                                  },
                                  icon:
                                      Icon(Icons.video_call_rounded, size: 35)),
                              IconButton(
                                  icon: Icon(Icons.attach_file, size: 32),
                                  onPressed: () async {
                                    final result = await FilePicker.platform
                                        .pickFiles(
                                            allowMultiple: true,
                                            type: FileType.custom,
                                            allowedExtensions: [
                                          'pdf',
                                          'doc',
                                        ]);
                                    if (result != null) {
                                      files = await _patientData
                                          .prepareFiles(result.paths);
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
                                var data = await _patientData.uploadMediaFiles({
                                  'image': images,
                                  'video': videos,
                                  'file': files
                                }, category, userId);
                                await _patientData
                                    .addMedicalData(patientId, "pathology", {
                                  'title': title,
                                  'result': result,
                                  'doctor': doctor,
                                  'date':
                                      "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                  'place': place,
                                  "media": data
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
                              width: MediaQuery.of(context).size.width * 0.2,
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
                    )),
              )),
              pathologyList.length == 0 && empty == 1
                  ? LoadingHeart()
                  : empty == 0
                      ? EmptyRecord()
                      : Container(
                          child: RefreshIndicator(
                              onRefresh: setData,
                              color: Colors.deepPurple,
                              child: ListView.builder(
                                  itemCount: pathologyList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PathologyList(
                                      title: pathologyList[index]['title'],
                                      result: pathologyList[index]['result'],
                                      doctor: pathologyList[index]['doctor'],
                                      place: pathologyList[index]['place'],
                                      date: pathologyList[index]['date'],
                                      patientId: patientId,
                                      recordId: pathologyList[index]
                                          ['documentid'],
                                      media: pathologyList[index]['media'],
                                    );
                                  })))
            ],
          ),
        ));
  }
}
