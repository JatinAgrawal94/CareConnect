import 'package:careconnect/models/registereduser.dart';
import 'package:careconnect/screens/userdataforms/doctor_update_form.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/doctorData.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:careconnect/components/loading.dart';
import 'package:provider/provider.dart';

class DoctorProfile extends StatefulWidget {
  final String doctorId;
  DoctorProfile({Key key, @required this.doctorId}) : super(key: key);

  @override
  _DoctorProfileState createState() => _DoctorProfileState(doctorId);
}

class _DoctorProfileState extends State<DoctorProfile> {
  DoctorData _doctorData = DoctorData();
  AuthService auth = AuthService();
  final String doctorId;
  String userId;
  var user;
  var role;
  var data;
  static String imageURL;
  _DoctorProfileState(this.doctorId);
  static var doctorInfo = Map<String, dynamic>();

  void getRole(value) {
    setState(() {
      this.role = value;
    });
  }

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
  List info = [
    "Name",
    "UserId",
    "Email",
    "Date of Birth",
    "Gender",
    "Blood Group",
    "Designation",
    'Type',
    'Appointment',
    "Contact",
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
        body: doctorInfo.isEmpty
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
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)),
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
