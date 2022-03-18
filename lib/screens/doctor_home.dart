import 'package:careconnect/components/emptypatient.dart';
import 'package:careconnect/components/loading.dart';
import 'package:careconnect/components/patientlisttile.dart';
import 'package:careconnect/screens/doctor_medical_screen.dart';
import 'package:careconnect/screens/userdataforms/patient_add_form.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';

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
  GeneralFunctions general = GeneralFunctions();
  var patientList = [];
  String documentId;
  String profileImageURL;
  var emptyPatients = 1;

  @override
  void initState() {
    super.initState();
    general.getDocsId(email, 'Doctor').then((value) {
      setState(() {
        documentId = value['documentId'];
      });
    });
    general.getAllUser('patient').then((value) {
      value.forEach((element) {
        setState(() {
          patientList.add({
            'name': element['name'],
            'profileImageURL': element['profileImageURL'],
            'documentid': element['documentid'],
            'userid': element['userid']
          });
        });
      });
      if (patientList.length == 0) {
        setState(() {
          emptyPatients = 0;
        });
      }
    });
  }

  Future loadPatients() async {
    var data = await general.getAllUser('patient');
    var result = [];
    setState(() {
      this.patientList = null;
      data.forEach((element) => {
            setState(() {
              result.add({
                'name': element['name'],
                'profileImageURL': element['profileImageURL'],
                'documentid': element['documentid'],
                'userid': element['userid']
              });
            })
          });
      this.patientList = result;
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
                          builder: (BuildContext context) => DoctorInfo(
                                documentId: documentId,
                                email: email,
                              )));
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
        body: patientList.length == 0 && emptyPatients == 1
            ? LoadingHeart()
            : emptyPatients == 0
                ? EmptyPatientList()
                : Container(
                    child: RefreshIndicator(
                        onRefresh: loadPatients,
                        color: Colors.deepPurple,
                        child: ListView(
                            children: patientList.map((element) {
                          return PatientListTile(
                            documentId: element['documentid'],
                            userId: element['userid'],
                            profileImageURL: element['profileImageURL'],
                            name: element['name'],
                          );
                        }).toList()))));
  }
}
