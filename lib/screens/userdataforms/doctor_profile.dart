import 'package:careconnect/screens/userdataforms/doctor_update_form.dart';
import 'package:careconnect/services/doctorData.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:careconnect/components/loading.dart';

class DoctorProfile extends StatefulWidget {
  final String doctorId;
  DoctorProfile({Key key, @required this.doctorId}) : super(key: key);

  @override
  _DoctorProfileState createState() => _DoctorProfileState(doctorId);
}

class _DoctorProfileState extends State<DoctorProfile> {
  DoctorData _doctorData = DoctorData();
  final String doctorId;
  String userId;
  static String imageURL;
  _DoctorProfileState(this.doctorId);
  static var doctorInfo = Map<String, dynamic>();

  @override
  void initState() {
    super.initState();
    _doctorData.getDoctorInfo(doctorId).then((value) {
      setState(() {
        doctorInfo = value;
        userId = doctorInfo['userid'];
      });
      _doctorData.getProfileImageURL(userId).then((value) {
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
    "Email",
    "Date of Birth",
    "Gender",
    "Blood Group",
    "Designation",
    "Contact",
    "Address"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          shadowColor: Colors.transparent,
        ),
        body: doctorInfo.isEmpty
            ? LoadingHeart()
            : Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  // _showpicker(context);
                                },
                                child: Container(
                                  color: Colors.white,
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
                                                        BorderRadius.circular(
                                                            100),
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
                                )))
                      ],
                    ),
                    Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                                  child: DoctorForm(
                                                      doctorId: this.doctorId),
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
                                      color: Colors.white10),
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
                                          child: Text(doctorInfo[_doctorData
                                                  .doctorInfoKeys[index]]
                                              .toString()))
                                    ],
                                  ));
                            }))
                  ],
                ),
              ));
  }
}
