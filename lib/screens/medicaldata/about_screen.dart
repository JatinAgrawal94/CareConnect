import 'package:careconnect/models/registereduser.dart';
import 'package:careconnect/screens/userdataforms/patient_update_form.dart';
import 'package:careconnect/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:careconnect/services/patientdata.dart';
import 'dart:io';
import 'package:careconnect/components/loading.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatefulWidget {
  final String patientId;

  AboutScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState(patientId);
}

class _AboutScreenState extends State<AboutScreen> {
  PatientData _patientData = PatientData();
  AuthService auth = AuthService();
  final String patientId;
  static String userId;
  static String imageURL;
  var user;
  var role;
  static var patientInfo = Map<String, dynamic>();
  _AboutScreenState(this.patientId);

  void getRole(value) {
    setState(() {
      this.role = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _patientData.getPatientInfo(this.patientId).then((value) {
      setState(() {
        patientInfo = value;
        userId = patientInfo['userid'];
      });
      _patientData.getProfileImageURL(userId).then((value) {
        setState(() {
          imageURL = value;
        });
      });
    });
  }

  final ImagePicker picker = ImagePicker();
  PickedFile _image;
  List info = [
    "Name",
    "UserId",
    "Email",
    "Date of Birth",
    "Gender",
    "Blood Group",
    "Contact",
    "Insurance No",
    "Address"
  ];

  @override
  Widget build(BuildContext context) {
    user = Provider.of<RegisteredUser>(context);
    getRole(user.roleGet);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[300],
          iconTheme: IconThemeData(color: Colors.black),
          shadowColor: Colors.transparent,
        ),
        body: (patientInfo.isEmpty && imageURL != null)
            ? LoadingHeart()
            : Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple[300],
                            border: Border.all(color: Colors.deepPurple[300])),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              color: Colors.deepPurple[300],
                              height: 170,
                              padding: EdgeInsets.all(15),
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
                              ),
                            ))
                          ],
                        )),
                    Container(
                        color: Colors.deepPurple[300],
                        child: Row(
                          mainAxisAlignment: role == "admin"
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.center,
                          children: <Widget>[
                            SafeArea(
                                right: true,
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.edit),
                                  label: Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GestureDetector(
                                                  onTap: () {
                                                    FocusScopeNode
                                                        currentFocus =
                                                        FocusScope.of(context);
                                                    if (!currentFocus
                                                            .hasPrimaryFocus &&
                                                        currentFocus
                                                                .focusedChild !=
                                                            null) {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          .unfocus();
                                                    }
                                                  },
                                                  child: PatientForm(
                                                      patientId:
                                                          this.patientId),
                                                )));
                                  },
                                )),
                          ],
                        )),
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: info.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: 0.5)),
                                      color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding:
                                              EdgeInsets.fromLTRB(7, 10, 6, 10),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          width: 80,
                                          child: Text(
                                            info[index],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Flexible(
                                          child: Text(patientInfo[_patientData
                                                  .patientInfoKeys[index]]
                                              .toString()))
                                    ],
                                  ));
                            }))
                  ],
                ),
              ));
  }
}
