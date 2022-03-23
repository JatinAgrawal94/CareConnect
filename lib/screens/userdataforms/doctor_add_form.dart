import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/general.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:careconnect/services/doctorData.dart';

class DoctorAddForm extends StatefulWidget {
  DoctorAddForm({Key key}) : super(key: key);
  @override
  _DoctorAddFormState createState() => _DoctorAddFormState();
}

class _DoctorAddFormState extends State<DoctorAddForm> {
  final GlobalKey<FormState> doctoraddformkey = GlobalKey<FormState>();
  ImagePicker picker = ImagePicker();
  AuthService auth = AuthService();
  PickedFile _image;
  PatientData patientData = PatientData();
  DoctorData doctorData = DoctorData();
  GeneralFunctions general = GeneralFunctions();
  String documentId = '';
  static String imageURL;
  static var patientInfo = Map<String, dynamic>();
  DateTime selecteddate = DateTime.now();
  int gender = patientInfo['gender'] == 'Male'
      ? 0
      : patientInfo['gender'] == 'Female'
          ? 1
          : 2;
  String bloodgroup = "A+";
  String contact = "";
  String designation = "";
  String address = "";
  String name = "";
  String email = "";
  String doctype = "";
  String appointmentTimings = "";

  _imgfromCamera() async {
    final pickerfile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (mounted) {}
    setState(() {
      _image = pickerfile;
    });
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Doctor"),
          backgroundColor: Colors.deepPurple,
        ),
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
                                    borderRadius: BorderRadius.circular(100),
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
                  ],
                ),
// --------------------------form begins here---------------------------------------//
                Form(
                    key: doctoraddformkey,
                    child: Column(
                      children: <Widget>[
                        // ------------------------------------name text field begins
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Name",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 18),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
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
                                    keyboardType: TextInputType.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 1,
                                        ))),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Email",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 18),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
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
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 1,
                                        ))),
                                  ))
                            ],
                          ),
                        ),
                        // ------------------date of birth field
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Date of Birth",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Text(
                                  "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}"
                                      .split(' ')[0]),
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
                                width: MediaQuery.of(context).size.width * 0.3,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Contact",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 18),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
                                    onChanged: (val) {
                                      if (mounted) {
                                        setState(() {
                                          contact = val;
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 1,
                                        ))),
                                  ))
                            ],
                          ),
                        ),
                        // ---------------------insurance no field begins here.
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Designation",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 18),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
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
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 1,
                                        ))),
                                  ))
                            ],
                          ),
                        ),

                        // appointmenttimingbeginhere
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Appointment Timing",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 18),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
                                    onChanged: (val) {
                                      if (mounted) {
                                        setState(() {
                                          appointmentTimings = val;
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    maxLength: 16,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 1,
                                        ))),
                                  ))
                            ],
                          ),
                        ),
                        // -----------------------doctype field begins here
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Type",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 18),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
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
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 1,
                                        ))),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Address",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 18),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
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
                                    maxLines: 3,
                                    keyboardType: TextInputType.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.deepPurple)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 1,
                                        ))),
                                  )),
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
                                    if (doctoraddformkey.currentState
                                        .validate()) {
                                      final result = await auth.createNewUser(
                                          email, 'doctor', contact);
                                      if (result['code'] ==
                                              "auth/created-new-user" &&
                                          result['message'] == 'User created') {
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            msg: "Doctor Added",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.SNACKBAR,
                                            backgroundColor: Colors.grey,
                                            textColor: Colors.white,
                                            fontSize: 15,
                                            timeInSecForIosWeb: 1);
                                        var profileImageURL;
                                        if (_image != null) {
                                          profileImageURL =
                                              await general.uploadProfileImage(
                                                  File(_image.path),
                                                  result['userid']);
                                        }
                                        await auth.addUser('Doctor', {
                                          'name': name,
                                          'email': email,
                                          'dateofbirth':
                                              "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}",
                                          'gender': gender == 0
                                              ? 'Male'
                                              : gender == 1
                                                  ? 'Female'
                                                  : 'Other',
                                          'bloodgroup': bloodgroup,
                                          'contact': contact,
                                          'designation': designation,
                                          'doctype': doctype,
                                          'timing': appointmentTimings,
                                          'address': address,
                                          'userid': result['userid'],
                                          'profileImageURL': profileImageURL
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: result['message'],
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.SNACKBAR,
                                            backgroundColor: Colors.grey,
                                            textColor: Colors.white,
                                            fontSize: 15,
                                            timeInSecForIosWeb: 1);
                                      }
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
