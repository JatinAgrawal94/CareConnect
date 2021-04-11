import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PatientForm extends StatefulWidget {
  PatientForm({Key key}) : super(key: key);

  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  ImagePicker picker = ImagePicker();
  PickedFile _image;

  String _name = "";
  String _email = "";
  String _dob = "";
  int _gender = 0;
  String _bloodgroup = "";
  String _contact = "";
  String _insuranceno = "";
  String _address = "";

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
        appBar: AppBar(title: Text("Patient Form")),
        body: SingleChildScrollView(
          child: Container(
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
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          )),
                        )),
                    IconButton(
                      icon: Icon(Icons.perm_contact_cal),
                      onPressed: () {},
                      iconSize: 50,
                      color: Colors.yellow[800],
                    )
                  ],
                ),
                Form(
                    child: Column(
                  children: <Widget>[
                    Text("Name"),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field can't be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field can't be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field can't be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.datetime,
                    ),
                    Row(
                      children: <Widget>[
                        Text("Male"),
                        Radio(
                            value: 0, groupValue: _gender, onChanged: (val) {}),
                        Text("Female"),
                        Radio(
                          value: 1,
                          groupValue: _gender,
                          onChanged: (val) {},
                        ),
                        Text("Other"),
                        Radio(
                            value: 2, groupValue: _gender, onChanged: (val) {})
                      ],
                    ),
                    DropdownButton(
                      value: _bloodgroup,
                      items: [
                        DropdownMenuItem(
                          child: Text('A+'),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text('A-'),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text('B+'),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text('B-'),
                          value: 3,
                        ),
                        DropdownMenuItem(
                          child: Text('O+'),
                          value: 4,
                        ),
                        DropdownMenuItem(
                          child: Text('O-'),
                          value: 5,
                        ),
                        DropdownMenuItem(
                          child: Text('AB+'),
                          value: 6,
                        ),
                        DropdownMenuItem(
                          child: Text('AB-'),
                          value: 7,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _bloodgroup = value;
                        });
                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field can't be empty";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field can't be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field can't be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Field can't be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    )
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
