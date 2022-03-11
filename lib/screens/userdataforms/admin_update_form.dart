import 'package:careconnect/components/loading.dart';
import 'package:careconnect/services/admin_data.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class AdminForm extends StatefulWidget {
  final String adminId;
  AdminForm({Key key, @required this.adminId}) : super(key: key);

  @override
  _AdminFormState createState() => _AdminFormState(this.adminId);
}

class _AdminFormState extends State<AdminForm> {
  final GlobalKey<FormState> adminupdateformkey = GlobalKey<FormState>();

  final String adminId;
  _AdminFormState(this.adminId);
  AdminData _adminData = AdminData();
  ImagePicker picker = ImagePicker();
  GeneralFunctions general = GeneralFunctions();
  PickedFile _image;
  String userId;

  static String imageURL;
  static var adminInfo = Map<String, dynamic>();

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
  String address = " ";
  String name = " ";
  String email = " ";

  @override
  void initState() {
    super.initState();
    _adminData.getAdminInfo(adminId).then((value) {
      setState(() {
        adminInfo = value;
        imageURL = adminInfo['profileImageURL'];
        userId = adminInfo['userid'];
        name = adminInfo['name'];
        email = adminInfo['email'];
        imageURL = adminInfo['profileImageURL'];
        contact = adminInfo['contact'].toString();
        bloodgroup = adminInfo['bloodgroup'];
        address = adminInfo['address'];
        gender = adminInfo['gender'] == 'Male'
            ? 0
            : adminInfo['gender'] == 'Female'
                ? 1
                : 2;
      });
      convertDate(adminInfo['dateofbirth']).then((value) {
        setState(() {
          selecteddate = DateTime.parse(value);
        });
      });
    });
  }

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
    return (address == "" && imageURL == null)
        ? LoadingHeart()
        : Scaffold(
            appBar: AppBar(
                title: Text("Update Admin Info"),
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
                                      adminId, userId, 'Admin');
                                  setState(() {
                                    _image = null;
                                    imageURL = null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple),
                                child: Text("Remove Profile Photo"))
                            : Text("")
                      ],
                    ),
// --------------------------form begins here---------------------------------------//
                    Form(
                        key: adminupdateformkey,
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
                                      "${selecteddate.day}/${selecteddate.month}/${selecteddate.year}"),
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
                                      setState(() {
                                        gender = val;
                                      });
                                    }),
                                Text("Female", style: TextStyle(fontSize: 20)),
                                Radio(
                                  activeColor: Colors.deepPurple,
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
                                    activeColor: Colors.deepPurple,
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
                                          setState(() {
                                            contact = val;
                                          });
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
                              margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (adminupdateformkey.currentState
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
                                              adminId,
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
                                                'address': address,
                                                'profileImageURL':
                                                    newImageURL == null
                                                        ? imageURL
                                                        : newImageURL
                                              },
                                              'Admin');
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
