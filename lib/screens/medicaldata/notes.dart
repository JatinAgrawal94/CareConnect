import 'package:careconnect/components/emptyrecord.dart';
import 'package:careconnect/components/notes.dart';
import 'package:careconnect/components/photogrid.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:careconnect/components/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class NotesScreen extends StatefulWidget {
  final String patientId;
  final String userId;
  NotesScreen({Key key, @required this.patientId, this.userId})
      : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState(patientId, this.userId);
}

class _NotesScreenState extends State<NotesScreen> {
  String category = "notes";
  final String patientId;
  final String userId;
  String title;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String description;
  _NotesScreenState(this.patientId, this.userId);
  PatientData _patientData = PatientData();
  List images = [];
  List videos = [];
  List files = [];
  List notesList = [];
  var empty = 1;
  @override
  void initState() {
    super.initState();
    _patientData.getCategoryData('notes', patientId).then((value) {
      value.forEach((item) {
        if (mounted) {
          setState(() {
            notesList.add(item);
          });
        }
      });
      if (notesList.length == 0) {
        if (mounted) {
          setState(() {
            empty = 0;
          });
        }
      }
    });
  }

  Future setData() async {
    var data = await _patientData.getCategoryData("notes", patientId);
    if (mounted) {
      setState(() {
        this.notesList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Notes'),
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
              Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  child: Form(
                      key: formkey,
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Form(
                                child: TextFormField(
                                  cursorColor: Colors.deepPurple,
                                  onChanged: (value) {
                                    if (mounted) {
                                      setState(() {
                                        title = value;
                                      });
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
                              )),
                          Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              child: Form(
                                child: TextFormField(
                                  cursorColor: Colors.deepPurple,
                                  onChanged: (value) {
                                    if (mounted) {
                                      setState(() {
                                        description = value;
                                      });
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Notes",
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.deepPurple))),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.all(5),
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
                                          for (var j = 0;
                                              j < result.paths.length;
                                              j++) {
                                            var sizeInMb = File(result.paths[j])
                                                    .lengthSync() /
                                                (1024 * 1024);
                                            if (sizeInMb > 5) {
                                              Fluttertoast.showToast(
                                                  backgroundColor: Colors.grey,
                                                  msg: "Cannot Upload " +
                                                      _patientData.getName(
                                                          File(result.paths[j])
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
                                          for (var j = 0;
                                              j < result.paths.length;
                                              j++) {
                                            var sizeInMb = File(result.paths[j])
                                                    .lengthSync() /
                                                (1024 * 1024);
                                            if (sizeInMb > 5) {
                                              Fluttertoast.showToast(
                                                  backgroundColor: Colors.grey,
                                                  msg: "Cannot Upload " +
                                                      _patientData.getName(
                                                          File(result.paths[j])
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
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.attach_file, size: 32),
                                      onPressed: () async {
                                        final result = await FilePicker.platform
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
                                            var sizeInMb = File(result.paths[j])
                                                    .lengthSync() /
                                                (1024 * 1024);
                                            if (sizeInMb > 5) {
                                              Fluttertoast.showToast(
                                                  backgroundColor: Colors.grey,
                                                  msg: "Cannot Upload " +
                                                      _patientData.getName(
                                                          File(result.paths[j])
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
                          Row(
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
                                            patientId, "notes", {
                                          'title': title,
                                          'description': description,
                                          'media': data
                                        });
                                      } else {}
                                    },
                                    child: Text("Save",
                                        style: TextStyle(fontSize: 20))),
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
                                                  builder:
                                                      (BuildContext context) =>
                                                          PhotoGrid(
                                                            image: images,
                                                            video: videos,
                                                            file: files,
                                                            filetype: "new",
                                                          )));
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
                              ])
                        ],
                      ))),
              notesList.length == 0 && empty == 1
                  ? LoadingHeart()
                  : empty == 0
                      ? EmptyRecord()
                      : Container(
                          child: RefreshIndicator(
                              onRefresh: setData,
                              color: Colors.deepPurple,
                              child: ListView.builder(
                                  itemCount: notesList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return NotesList(
                                        title: notesList[index]['title'],
                                        description: notesList[index]
                                            ['description'],
                                        patientId: patientId,
                                        recordId: notesList[index]
                                            ['documentid'],
                                        media: notesList[index]['media']);
                                  }))),
            ],
          ),
        ));
  }
}
