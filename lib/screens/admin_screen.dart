import 'package:careconnect/components/loading.dart';
import 'package:careconnect/screens/medical_info.dart';
import 'package:careconnect/screens/userdataforms/admin_profile.dart';
import 'package:careconnect/screens/userdataforms/doctor_add_form.dart';
import 'package:careconnect/screens/userdataforms/doctor_profile.dart';
import 'package:careconnect/screens/userdataforms/patient_add_form.dart';
import 'package:careconnect/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careconnect/services/admin_data.dart';

class AdminHome extends StatefulWidget {
  final String email;
  AdminHome({Key key, this.email}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState(this.email);
}

class _AdminHomeState extends State<AdminHome> {
  String email;
  _AdminHomeState(this.email);
  AuthService auth = AuthService();
  AdminData _adminData = AdminData();
  CollectionReference patientList =
      FirebaseFirestore.instance.collection('Patient');
  CollectionReference doctorList =
      FirebaseFirestore.instance.collection('Doctor');
  static String patientDocumentId;
  static String doctorDocumentId;
  static String adminDocumentId;

  @override
  void initState() {
    super.initState();
    _adminData.getDocsId(email).then((value) {
      setState(() {
        adminDocumentId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: Text("Admin"),
              actions: [
                IconButton(
                    icon: Icon(Icons.person_rounded),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdminProfile(adminId: adminDocumentId)));
                    }),
                IconButton(
                    icon: Icon(Icons.power_settings_new_rounded),
                    onPressed: () {
                      auth.signoutmethod();
                    }),
              ],
              bottom: TabBar(indicatorColor: Colors.white, tabs: [
                Tab(child: Text("Patient")),
                Tab(child: Text("Doctor"))
              ]),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.add),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible:
                      true, //this means the user must tap a button to exit the Alert Dialog
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DoctorAddForm()));
                                },
                                child: Text(
                                  'Doctor',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.deepPurple),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PatientAddForm()));
                                },
                                child: Text('Patient',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.deepPurple)))
                          ],
                        ),
                      ),
                      actions: <Widget>[],
                    );
                  },
                );
              },
            ),
            body: TabBarView(
              children: [
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: patientList.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingHeart();
                        }

                        return new ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                          return Container(
                            child: ListTile(
                              leading: Icon(Icons.person, size: 40.0),
                              title: new Text(
                                document.data()['name'],
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: new Text(
                                  "Patient Id: " + document.data()['userid']),
                              trailing: Icon(Icons.info),
                              onTap: () {
                                patientDocumentId = document.id;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MedicalScreen(
                                            patientId: patientDocumentId)));
                              },
                            ),
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.3)),
                          );
                        }).toList());
                      }),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: doctorList.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingHeart();
                        }

                        return new ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                          return Container(
                            child: ListTile(
                              leading: Icon(Icons.person, size: 40.0),
                              title: new Text(
                                document.data()['name'],
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: new Text(
                                  "Doctor Id: " + document.data()['userid']),
                              trailing: Icon(Icons.info),
                              onTap: () {
                                doctorDocumentId = document.id;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DoctorProfile(
                                            doctorId: doctorDocumentId)));
                              },
                            ),
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.3)),
                          );
                        }).toList());
                      }),
                )
              ],
            )));
  }
}
