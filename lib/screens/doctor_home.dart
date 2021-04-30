import 'package:careconnect/components/loading.dart';
import 'package:careconnect/screens/medical_info.dart';
import 'package:careconnect/screens/userdataforms/patient_add_form.dart';
import 'package:careconnect/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class DoctorHome extends StatefulWidget {
  DoctorHome({Key key}) : super(key: key);

  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  AuthService auth = AuthService();
  dynamic user = AuthService().user;
  PatientData patient = PatientData();
  static String patientId;
  // static List patientList;
  CollectionReference patientList =
      FirebaseFirestore.instance.collection('Patient');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Doctor"),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  auth.signoutmethod();
                },
                child: Icon(Icons.power_settings_new_outlined)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
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
                    subtitle: new Text("Patient Id: " + document.id),
                    trailing: Icon(Icons.info),
                    onTap: () {
                      patientId = document.id;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MedicalScreen(patientId: patientId)));
                    },
                  ),
                  decoration: BoxDecoration(border: Border.all(width: 0.3)),
                );
              }).toList());
            }));
  }
}
