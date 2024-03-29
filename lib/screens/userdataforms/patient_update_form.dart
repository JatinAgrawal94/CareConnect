import 'package:careconnect/components/loading.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/general.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class PatientForm extends StatefulWidget {
  final String patientId;
  PatientForm({Key key, @required this.patientId}) : super(key: key);

  @override
  _PatientFormState createState() => _PatientFormState(this.patientId);
}

class _PatientFormState extends State<PatientForm> {
  final GlobalKey<FormState> patientupdateformkey = GlobalKey<FormState>();
  final String patientId;
  String userId;
  _PatientFormState(this.patientId);
  ImagePicker picker = ImagePicker();
  PickedFile _image;
  PatientData patientData = PatientData();
  AuthService auth = AuthService();
  GeneralFunctions general = GeneralFunctions();
  static var patientInfo = Map<String, dynamic>();

  Future convertDate(String date) async {
    var g = date.split('/').reversed.toList();
    if (int.parse(g[1]) / 10 < 1) {
      g[1] = "0" + g[1];
    }

    if (int.parse(g[2]) / 10 < 1) {
      g[2] = "0" + g[2];
    }
    return g.join('-').toString();
  }

  DateTime selecteddate = DateTime.now();
  int gender = 0;
  String bloodgroup;
  String contact = " ";
  String insuranceno = " ";
  String address = ' ';
  String name = " ";
  String email = " ";
  String profileImageURL;
  @override
  void initState() {
    super.initState();
    general.getUserInfo(patientId, 'Patient').then((value) {
      if (mounted) {
        setState(() {
          patientInfo = value;
          profileImageURL = patientInfo['profileImageURL'];
          userId = patientInfo['userid'];
          email = patientInfo['email'];
          name = patientInfo['name'];
          address = patientInfo['address'];
          bloodgroup = patientInfo['bloodgroup'];
          insuranceno = patientInfo['insuranceno'];
          contact = patientInfo['contact'].toString();
          gender = patientInfo['gender'] == 'Male'
              ? 0
              : patientInfo['gender'] == 'Female'
                  ? 1
                  : 2;
        });
      }
      convertDate(patientInfo['dateofbirth']).then((value) {
        if (mounted) {
          setState(() {
            selecteddate = DateTime.parse(value);
          });
        }
      });
    });
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
    return patientInfo.isEmpty
        ? LoadingHeart()
        : Scaffold(
            appBar: AppBar(
              title: Text("Update Patient Data"),
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
                                        child: profileImageURL != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  profileImageURL,
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
                        profileImageURL != null
                            ? ElevatedButton(
                                onPressed: () async {
                                  await general.deleteProfileImageURL(
                                      patientId, userId, 'Patient');
                                  if (mounted) {
                                    setState(() {
                                      _image = null;
                                      profileImageURL = null;
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
                        key: patientupdateformkey,
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
                            // ---------------------insurance no field begins here.
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "Insurance No",
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
                                              insuranceno = val;
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
                                                    text: insuranceno,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset: insuranceno
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
                                        if (patientupdateformkey.currentState
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
                                          String newProfileURL;
                                          if (_image != null) {
                                            newProfileURL = await general
                                                .uploadProfileImage(
                                                    File(_image.path),
                                                    '$userId');
                                          }
                                          await general.updateUserinfo(
                                              patientId,
                                              {
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
                                                'insuranceno': insuranceno,
                                                'address': address,
                                                'profileImageURL':
                                                    newProfileURL == null
                                                        ? profileImageURL
                                                        : newProfileURL
                                              },
                                              'Patient');
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
