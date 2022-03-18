import 'package:careconnect/components/doctorlisttile.dart';
import 'package:careconnect/components/emptydoctor.dart';
import 'package:careconnect/components/emptypatient.dart';
import 'package:careconnect/components/loading.dart';
import 'package:careconnect/components/patientlisttile.dart';
import 'package:careconnect/screens/userdataforms/admin_profile.dart';
import 'package:careconnect/screens/userdataforms/doctor_add_form.dart';
import 'package:careconnect/screens/userdataforms/patient_add_form.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';

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
  GeneralFunctions general = GeneralFunctions();
  static String adminDocumentId;
  List patients = [];
  List doctors = [];
  var emptyPatients = 1;
  var emptyDoctors = 1;

  @override
  void initState() {
    super.initState();
    general.getAllUser('patient').then((value) {
      value.forEach((element) {
        setState(() {
          patients.add({
            'name': element['name'],
            'profileImageURL': element['profileImageURL'],
            'documentid': element['documentid'],
            'userid': element['userid']
          });
        });
        if (patients.length == 0) {
          setState(() {
            emptyPatients = 0;
          });
        }
      });
    });
    general.getAllUser('doctor').then((value) {
      value.forEach((element) {
        setState(() {
          doctors.add({
            'name': element['name'],
            'profileImageURL': element['profileImageURL'],
            'documentid': element['documentid'],
            'userid': element['userid']
          });
        });
        if (doctors.length == 0) {
          setState(() {
            emptyDoctors = 0;
          });
        }
      });
    });
    general.getDocsId(email, 'Admin').then((value) {
      setState(() {
        adminDocumentId = value['documentId'];
      });
    });
  }

  Future loadDoctors() async {
    var data = await general.getAllUser('doctor');
    var result = [];
    setState(() {
      this.doctors = null;
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
      this.doctors = result;
    });
  }

  Future loadPatients() async {
    var data = await general.getAllUser('patient');
    var result = [];
    setState(() {
      this.patients = null;
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
      this.patients = result;
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
                patients.length == 0 && emptyPatients == 1
                    ? LoadingHeart()
                    : emptyPatients == 0
                        ? EmptyPatientList()
                        : Container(
                            child: RefreshIndicator(
                                color: Colors.deepPurple,
                                onRefresh: loadPatients,
                                child: ListView.builder(
                                    itemCount: patients.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return PatientListTile(
                                          documentId: patients[index]
                                              ['documentid'],
                                          name: patients[index]['name'],
                                          profileImageURL: patients[index]
                                              ['profileImageURL'],
                                          userId: patients[index]['userid']);
                                    }))),
                doctors.length == 0 && emptyDoctors == 1
                    ? LoadingHeart()
                    : emptyDoctors == 0
                        ? EmptyDoctorList()
                        : Container(
                            child: RefreshIndicator(
                                color: Colors.deepPurple,
                                onRefresh: loadDoctors,
                                child: ListView.builder(
                                    itemCount: doctors.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return DoctorListTile(
                                          documentId: doctors[index]
                                              ['documentid'],
                                          name: doctors[index]['name'],
                                          profileImageURL: doctors[index]
                                              ['profileImageURL'],
                                          userId: doctors[index]['userid']);
                                    })))
              ],
            )));
  }
}
