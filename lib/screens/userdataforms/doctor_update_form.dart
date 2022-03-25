import 'package:careconnect/components/loading.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class DoctorForm extends StatefulWidget {
  final String doctorId;
  DoctorForm({Key key, @required this.doctorId}) : super(key: key);

  @override
  _DoctorFormState createState() => _DoctorFormState(this.doctorId);
}

class _DoctorFormState extends State<DoctorForm> {
  final GlobalKey<FormState> doctorupdateformkey = GlobalKey<FormState>();

  final String doctorId;
  _DoctorFormState(this.doctorId);
  ImagePicker picker = ImagePicker();
  PickedFile _image;
  String userId;
  GeneralFunctions general = GeneralFunctions();
  static String imageURL;
  static var doctorInfo = Map<String, dynamic>();

  Future convertDate(String date) async {
    var g = date.split('/').reversed.toList();
    if (int.parse(g[1]) / 10 < 1) {
      g[1] = "0" + int.parse(g[1]).toString();
    }
    if (int.parse(g[2]) / 10 < 1) {
      g[2] = "0" + int.parse(g[2]).toString();
    }
    return g.join('-').toString();
  }

// 09:00 AM-10:00 AM
  void convertTime(String timings) {
    var time = timings.split('-');
    var hour;
    var min;
    var timeOfday;
    timeOfday = time[0].split(' ')[1];
    hour = int.parse(time[0].split(' ')[0].split(':')[0]);
    min = int.parse(time[0].split(' ')[0].split(':')[1]);
    if (timeOfday == 'PM') {
      hour = hour + 12;
    }
    setState(() {
      begin = TimeOfDay(hour: hour, minute: min);
    });
    timeOfday = time[1].split(' ')[1];
    hour = int.parse(time[1].split(' ')[0].split(':')[0]);
    min = int.parse(time[1].split(' ')[0].split(':')[1]);
    if (timeOfday == 'PM') {
      hour = hour + 12;
    }
    setState(() {
      end = TimeOfDay(hour: hour, minute: min);
    });
  }

  DateTime selecteddate = DateTime.now();
  TimeOfDay begin = TimeOfDay.now();
  TimeOfDay end = TimeOfDay.now();
  // TimeOfDay g=TimeOfDay();
  int gender = 0;
  String bloodgroup;
  String contact = " ";
  String designation = " ";
  String appointmentTimings = " ";
  String address = " ";
  String name = " ";
  String email = " ";
  String doctype = " ";
  String zoom = " ";

  @override
  void initState() {
    super.initState();
    general.getUserInfo(doctorId, 'Doctor').then((value) {
      if (mounted) {
        convertTime(value['timing']);
        setState(() {
          doctorInfo = value;
          appointmentTimings = doctorInfo['timing'];
          imageURL = doctorInfo['profileImageURL'];
          userId = doctorInfo['userid'];
          name = doctorInfo['name'];
          email = doctorInfo['email'];
          designation = doctorInfo['designation'];
          contact = doctorInfo['contact'].toString();
          bloodgroup = doctorInfo['bloodgroup'];
          doctype = doctorInfo['doctype'];
          address = doctorInfo['address'];
          zoom = doctorInfo['zoom'];
          gender = doctorInfo['gender'] == 'Male'
              ? 0
              : doctorInfo['gender'] == 'Female'
                  ? 1
                  : 2;
        });
      }
      convertDate(doctorInfo['dateofbirth']).then((value) {
        if (mounted) {
          setState(() {
            selecteddate = DateTime.parse(value);
          });
        }
      });
    });
  }

  _setTime(BuildContext context, int type) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: type == 0 ? begin : end,
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
        if (type == 0) {
          setState(() {
            begin = picked;
            this.appointmentTimings =
                "${begin.hour > 12 ? ((begin.hour - 12).toString()) : (begin.hour)}:${begin.minute < 10 ? ("0${begin.minute}") : (begin.minute)}" +
                    "  " +
                    "${begin.hour > 12 ? ("PM") : ("AM")}" "-" +
                    "${end.hour > 12 ? ((end.hour - 12).toString()) : (end.hour)}:${end.minute < 10 ? ("0${end.minute}") : (end.minute)}" +
                    "  " +
                    "${end.hour > 12 ? ("PM") : ("AM")}";
          });
        } else {
          setState(() {
            end = picked;
            this.appointmentTimings =
                "${begin.hour > 12 ? ((begin.hour - 12).toString()) : '0${begin.hour}'.toString()}:${begin.minute < 10 ? ("0${begin.minute}") : (begin.minute)}" +
                    "  " +
                    "${begin.hour > 12 ? ("PM") : ("AM")}" +
                    "-" +
                    "${end.hour > 12 ? ((end.hour - 12).toString()) : "0${end.hour}"}:${end.minute < 10 ? ("0${end.minute}") : (end.minute)}" +
                    "  " +
                    "${end.hour > 12 ? ("PM") : ("AM")}";
          });
        }
      }
    }
  }

  _imgfromCamera() async {
    final pickerfile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (mounted) {
      setState(() {
        _image = pickerfile;
      });
    }
  }

  _imgfromgallery() async {
    final galleryimage =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (mounted) {
      setState(() {
        _image = galleryimage;
      });
    }
  }

  void _showpicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
                  child: Wrap(children: <Widget>[
            ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("PhotoGallery"),
                onTap: () {
                  _imgfromgallery();
                  Navigator.of(context).pop();
                }),
            ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text("Camera"),
                onTap: () {
                  _imgfromCamera();
                  Navigator.of(context).pop();
                }),
          ])));
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
    if (picked != null && picked != selecteddate) if (mounted) {
      setState(() {
        selecteddate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return doctorInfo.isEmpty
        ? LoadingHeart()
        : Scaffold(
            appBar: AppBar(
                title: Text("Update Doctor Info"),
                backgroundColor: Colors.deepPurple),
            body: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                            width: 140,
                            height: 140,
                            child: GestureDetector(
                              onTap: () {
                                _showpicker(context);
                              },
                              child: Container(
                                  child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: _image != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          File(_image.path),
                                          width: 140,
                                          height: 140,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        width: 140,
                                        height: 140,
                                        child: imageURL != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  imageURL,
                                                  width: 140,
                                                  height: 140,
                                                  fit: BoxFit.fill,
                                                ),
                                              )
                                            : Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey[800],
                                              ),
                                      ),
                              )),
                            )),
                        imageURL != null
                            ? ElevatedButton(
                                onPressed: () async {
                                  await general.deleteProfileImageURL(
                                      doctorId, userId, 'Doctor');
                                  if (mounted) {
                                    setState(() {
                                      _image = null;
                                      imageURL = null;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple),
                                child: Text("Remove Profile Photo"))
                            : Text("")
                      ],
                    ),
// --------------------------form begins here---------------------------------------//
                    Form(
                        key: doctorupdateformkey,
                        child: Column(
                          children: <Widget>[
                            // ------------------------------------name text field begins
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "Name",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (val) {
                                          if (mounted) {
                                            setState(() {
                                              name = val;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Field can't be empty";
                                          }
                                          return null;
                                        },
                                        controller:
                                            TextEditingController.fromValue(
                                                TextEditingValue(
                                                    text: name,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                name.length))),
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
                            // ------------------------------------email text field
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "Email",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        readOnly: true,
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (val) {
                                          if (mounted) {
                                            setState(() {
                                              email = val;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Field can't be empty";
                                          }
                                          return null;
                                        },
                                        controller:
                                            TextEditingController.fromValue(
                                                TextEditingValue(
                                                    text: email,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                email.length))),
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                            // ------------------date of birth field
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      "Date of Birth",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Text("${selecteddate.day < 10 ? "0" + selecteddate.day.toString() : selecteddate.day}" +
                                      "/${selecteddate.month}/${selecteddate.year}"),
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
                            // ------------------gender selection radio buttons--------
                            Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Text(
                                      "Gender:",
                                      style: TextStyle(fontSize: 20),
                                    )),
                                Text("Male", style: TextStyle(fontSize: 20)),
                                Radio(
                                    activeColor: Colors.deepPurple,
                                    value: 0,
                                    groupValue: gender,
                                    onChanged: (val) {
                                      if (mounted) {
                                        setState(() {
                                          gender = val;
                                        });
                                      }
                                    }),
                                Text("Female", style: TextStyle(fontSize: 20)),
                                Radio(
                                  activeColor: Colors.deepPurple,
                                  value: 1,
                                  groupValue: gender,
                                  onChanged: (val) {
                                    if (mounted) {
                                      setState(() {
                                        gender = val;
                                      });
                                    }
                                  },
                                ),
                                Text("Other", style: TextStyle(fontSize: 20)),
                                Radio(
                                    activeColor: Colors.deepPurple,
                                    value: 2,
                                    groupValue: gender,
                                    onChanged: (val) {
                                      if (mounted) {
                                        setState(() {
                                          gender = val;
                                        });
                                      }
                                    })
                              ],
                            ),
                            // ----------- blood group selection
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text("Blood Group",
                                        style: TextStyle(fontSize: 18)),
                                  ),
                                  Container(
                                    child: DropdownButton<String>(
                                      value: bloodgroup,
                                      items: <String>[
                                        'A+',
                                        'A-',
                                        'B+',
                                        'B-',
                                        'O+',
                                        'O-',
                                        'AB+',
                                        'AB-'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem(
                                          child: Text(value,
                                              style: TextStyle(fontSize: 18)),
                                          value: value,
                                        );
                                      }).toList(),
                                      hint: Text("Select Blood Group"),
                                      onChanged: (String value) {
                                        if (mounted) {
                                          setState(() {
                                            bloodgroup = value;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // -----------------------------contact field begins here-----------
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "Contact",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (val) {
                                          if (mounted) {
                                            setState(() {
                                              contact = val;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value.length < 10) {
                                            return "Enter 10 digit contact number";
                                          }
                                          if (value.isEmpty) {
                                            return "Field can't be empty";
                                          }
                                          return null;
                                        },
                                        controller:
                                            TextEditingController.fromValue(
                                                TextEditingValue(
                                                    text: contact,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset: contact
                                                                .length))),
                                        keyboardType: TextInputType.phone,
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
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Timings",
                                      style: TextStyle(fontSize: 18)),
                                  Container(
                                      child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            _setTime(context, 0);
                                          },
                                          icon: Icon(
                                            Icons.timer,
                                            color: Colors.deepPurple,
                                          )),
                                      Text("${begin.hour > 12 ? ((begin.hour - 12).toString()) : (begin.hour)}:${begin.minute < 10 ? ("0${begin.minute}") : (begin.minute)}" +
                                          "  " +
                                          "${begin.hour > 12 ? ("PM") : ("AM")}")
                                    ],
                                  )),
                                  Container(
                                      child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            _setTime(context, 1);
                                          },
                                          icon: Icon(
                                            Icons.timer,
                                            color: Colors.deepPurple,
                                          )),
                                      Text("${end.hour > 12 ? ((end.hour - 12).toString()) : (end.hour)}:${end.minute < 10 ? ("0${end.minute}") : (end.minute)}" +
                                          "  " +
                                          "${end.hour > 12 ? ("PM") : ("AM")}")
                                    ],
                                  ))
                                ],
                              ),
                            ),
                            // ---------------------designation field begins here.
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "Designation",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (val) {
                                          if (mounted) {
                                            setState(() {
                                              designation = val;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Field can't be empty";
                                          }
                                          return null;
                                        },
                                        controller:
                                            TextEditingController.fromValue(
                                                TextEditingValue(
                                                    text: designation,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset: designation
                                                                .length))),
                                        keyboardType: TextInputType.text,
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
                            // doctortype field begins here
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "Type",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (val) {
                                          if (mounted) {
                                            setState(() {
                                              doctype = val;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Field can't be empty";
                                          }
                                          return null;
                                        },
                                        controller:
                                            TextEditingController.fromValue(
                                                TextEditingValue(
                                                    text: doctype,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset: doctype
                                                                .length))),
                                        keyboardType: TextInputType.text,
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

                            // -------------------address field begins here
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "Address",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (val) {
                                          if (mounted) {
                                            setState(() {
                                              address = val;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Field can't be empty";
                                          }
                                          return null;
                                        },
                                        controller:
                                            TextEditingController.fromValue(
                                                TextEditingValue(
                                                    text: address,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset: address
                                                                .length))),
                                        maxLines: 3,
                                        keyboardType: TextInputType.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.deepPurple,
                                                  width: 1.0)),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "Zoom Meeting ID&PWD",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        cursorColor: Colors.deepPurple,
                                        onChanged: (val) {
                                          if (mounted) {
                                            setState(() {
                                              zoom = val;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Field can't be empty";
                                          }
                                          return null;
                                        },
                                        controller:
                                            TextEditingController.fromValue(
                                                TextEditingValue(
                                                    text: zoom,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                zoom.length))),
                                        keyboardType: TextInputType.text,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (doctorupdateformkey.currentState
                                            .validate()) {
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                              msg: "Data Updated",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.SNACKBAR,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 15,
                                              timeInSecForIosWeb: 1);

                                          Navigator.pop(context);
                                          String newImageURL;
                                          if (_image != null) {
                                            newImageURL = await general
                                                .uploadProfileImage(
                                                    File(_image.path),
                                                    '$userId');
                                          }
                                          await general.updateUserinfo(
                                              doctorId,
                                              {
                                                'name': name,
                                                'email': email,
                                                'dateofbirth':
                                                    "${selecteddate.day < 10 ? "0" + selecteddate.day.toString() : selecteddate.day}" +
                                                        "/${selecteddate.month}/${selecteddate.year}",
                                                'gender': gender == 0
                                                    ? 'Male'
                                                    : gender == 1
                                                        ? 'Female'
                                                        : 'Other',
                                                'bloodgroup': bloodgroup,
                                                'contact': contact,
                                                'designation': designation,
                                                'address': address,
                                                'doctype': doctype,
                                                'timing': appointmentTimings,
                                                'zoom': zoom,
                                                'profileImageURL':
                                                    newImageURL == null
                                                        ? imageURL
                                                        : newImageURL
                                              },
                                              'Doctor');
                                        }
                                      },
                                      child: Text(
                                        "Save",
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
            )));
  }
}
