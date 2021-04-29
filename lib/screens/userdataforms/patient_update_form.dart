import 'package:careconnect/components/loading.dart';
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
  final String patientId;
  _PatientFormState(this.patientId);
  ImagePicker picker = ImagePicker();
  PickedFile _image;
  PatientData patientData = PatientData();
  // static var timearray = [0, 0, 0];
  // static int year = timearray[2];
  // static int month = timearray[1];
  // static int day = timearray[0];
  static String imageURL;
  static var patientInfo = Map<String, dynamic>();

  @override
  void initState() {
    super.initState();
    patientData.getPatientInfo(patientId).then((value) {
      setState(() {
        patientInfo = value;
      });
    });
    patientData.getProfileImageURL(patientId).then((value) {
      setState(() {
        imageURL = value;
      });
    });
  }

  DateTime selecteddate = DateTime.now();
  int gender = patientInfo['gender'] == 'Male'
      ? 0
      : patientInfo['gender'] == 'Female'
          ? 1
          : 2;
  String bloodgroup = patientInfo['bloodgroup'];
  String contact = patientInfo['phoneno'].toString();
  String insuranceno = patientInfo['insuranceno'];
  String address = patientInfo['address'];
  String name = patientInfo['name'];
  String email = patientInfo['email'];
  _imgfromCamera() async {
    final pickerfile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = pickerfile;
    });
  }

  _imgfromgallery() async {
    final galleryimage =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = galleryimage;
    });
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
    );
    if (picked != null && picked != selecteddate)
      setState(() {
        selecteddate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return patientInfo.isEmpty
        ? LoadingHeart()
        : Scaffold(
            appBar: AppBar(title: Text("Patient Form")),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.save),
              mini: true,
              onPressed: () async {
                await patientData.updatePatientinfo(patientId, {
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
                  'phoneno': contact,
                  'insuranceno': insuranceno,
                  'address': address
                });
                // dynamic data = await patientData.getPatientInfo(patientId);

                Navigator.pop(context);

                return Fluttertoast.showToast(
                    msg: "Data Saved",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 15,
                    timeInSecForIosWeb: 1);
              },
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
                        ElevatedButton(
                            onPressed: () async {
                              patientData.uploadFile(
                                  File(_image.path), patientId);
                            },
                            child: Text('Upload')),
                        IconButton(
                          icon: Icon(Icons.perm_contact_cal),
                          onPressed: () {},
                          iconSize: 50,
                          color: Colors.yellow[800],
                        )
                      ],
                    ),
// --------------------------form begins here---------------------------------------//
                    Form(
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
                                      setState(() {
                                        name = val;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    controller:
                                        TextEditingController(text: name),
                                    keyboardType: TextInputType.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(width: 1))),
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
                                      setState(() {
                                        email = val;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    controller:
                                        TextEditingController(text: email),
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(width: 1))),
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
                                value: 0,
                                groupValue: gender,
                                onChanged: (val) {
                                  setState(() {
                                    gender = val;
                                  });
                                }),
                            Text("Female", style: TextStyle(fontSize: 20)),
                            Radio(
                              value: 1,
                              groupValue: gender,
                              onChanged: (val) {
                                setState(() {
                                  gender = val;
                                });
                              },
                            ),
                            Text("Other", style: TextStyle(fontSize: 20)),
                            Radio(
                                value: 2,
                                groupValue: gender,
                                onChanged: (val) {
                                  setState(() {
                                    gender = val;
                                  });
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
                                    setState(() {
                                      bloodgroup = value;
                                    });
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
                                      setState(() {
                                        contact = val;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    controller:
                                        TextEditingController(text: contact),
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(width: 1))),
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
                                    "Insurance No",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 18),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
                                    onChanged: (val) {
                                      setState(() {
                                        insuranceno = val;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    controller: TextEditingController(
                                        text: insuranceno),
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(width: 1))),
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
                                      setState(() {
                                        address = val;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    controller:
                                        TextEditingController(text: address),
                                    maxLines: 3,
                                    keyboardType: TextInputType.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(width: 1))),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            )));
  }
}
