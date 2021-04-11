import 'package:careconnect/screens/userdataforms/patient_form.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:careconnect/services/patientdata.dart';
import 'dart:io';
import 'package:careconnect/components/loading.dart';

class AboutScreen extends StatefulWidget {
  final String patientId;
  AboutScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState(patientId);
}

class _AboutScreenState extends State<AboutScreen> {
  PatientData _patientData = PatientData();
  final String patientId;
  static var patientInfo = Map<String, dynamic>();
  _AboutScreenState(this.patientId);

  @override
  void initState() {
    _patientData.getPatientInfo(this.patientId).then((value) {
      setState(() {
        patientInfo = value;
      });
    });
    super.initState();
  }

  final ImagePicker picker = ImagePicker();
  PickedFile _image;
  List info = [
    "Name",
    "Email",
    "Date of Birth",
    "Gender",
    "Blood Group",
    "Contact",
    "Insurance No",
    "Address"
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          shadowColor: Colors.transparent,
        ),
        body: patientInfo.isEmpty
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
                                            child: Icon(
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
                                      primary: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PatientForm()));
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
                                          child: Text(patientInfo[_patientData
                                              .patientInfoKeys[index]]))
                                    ],
                                  ));
                            }))
                  ],
                ),
              ));
  }
}
