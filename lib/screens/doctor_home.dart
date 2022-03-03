import 'package:careconnect/components/loading.dart';
import 'package:careconnect/components/medical_info.dart';
import 'package:careconnect/screens/userdataforms/doctor_profile.dart';
import 'package:careconnect/screens/userdataforms/patient_add_form.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/doctorData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class DoctorHome extends StatefulWidget {
  final String email;
  DoctorHome({Key key, this.email}) : super(key: key);

  @override
  _DoctorHomeState createState() => _DoctorHomeState(this.email);
}

class _DoctorHomeState extends State<DoctorHome> {
  String email;
  _DoctorHomeState(this.email);
  AuthService auth = AuthService();
  PatientData patient = PatientData();
  DoctorData doctor = DoctorData();
  static String patientId;
  CollectionReference patientList =
      FirebaseFirestore.instance.collection('Patient');
  String documentId;

  @override
  void initState() {
    super.initState();
    doctor.getDocsId(email).then((value) {
      setState(() {
        documentId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Doctor"),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.person_rounded),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DoctorProfile(doctorId: documentId)));
                }),
            IconButton(
                onPressed: () {
                  auth.signoutmethod();
                },
                icon: Icon(
                  Icons.power_settings_new_outlined,
                  color: Colors.white,
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PatientAddForm()));
          },
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: patientList.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingHeart();
              }

              return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                return Container(
                  child: ListTile(
                    leading: Icon(Icons.person, size: 40.0),
                    title: new Text(
                      document.data()['name'],
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle:
                        new Text("Patient Id: " + document.data()['userid']),
                    trailing: Icon(Icons.info),
                    onTap: () {
                      patientId = document.id;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MedicalScreen(
                                    patientId: patientId,
                                    userId: document.data()['userid'],
                                  )));
                    },
                  ),
                  decoration: BoxDecoration(border: Border.all(width: 0.3)),
                );
              }).toList());
            }));
  }
}
