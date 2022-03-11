import 'package:careconnect/services/auth.dart';
import 'package:careconnect/services/general.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class MedicalScreen extends StatefulWidget {
  final String patientId;
  final bool patientScreen;
  final String userId;
  MedicalScreen(
      {Key key, @required this.patientId, this.patientScreen, this.userId})
      : super(key: key);

  @override
  _MedicalScreenState createState() =>
      _MedicalScreenState(this.patientId, this.patientScreen, this.userId);
}

class _MedicalScreenState extends State<MedicalScreen> {
  final String patientId;
  bool patientScreen;
  final String userId;
  _MedicalScreenState(this.patientId, this.patientScreen, this.userId);
  GeneralFunctions general = GeneralFunctions();
  PatientData _patientData = PatientData();
  AuthService auth = AuthService();
  String name = "Medical Data";
  List info = [
    "About",
    "Allergy",
    "Blood Glucose",
    "Blood Pressure",
    "Examination",
    "Family History",
    "Labtest",
    "Medical Visit",
    "Notes",
    "Pathology",
    "Prescription",
    "Radiology",
    "Surgery",
    "Vaccine",
    "Book Appointment"
  ];
  List iconList = [
    'assets/about.png',
    'assets/allergy.png',
    'assets/bloodglucose.png',
    'assets/bloodpressure.png',
    'assets/examination.png',
    'assets/history.png',
    'assets/labtest.png',
    'assets/medicalvisit.png',
    'assets/notes.png',
    'assets/pathology.png',
    'assets/prescription.png',
    'assets/radiology.png',
    'assets/surgery.png',
    'assets/vaccine.png',
    'assets/appointment.png'
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      patientScreen = patientScreen == null ? false : patientScreen;
    });
    if (patientScreen) {
      general.getUserInfo(patientId, 'Patient').then((value) {
        setState(() {
          name = value['name'];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text(name),
            actions: patientScreen
                ? [
                    IconButton(
                        onPressed: () {
                          auth.signoutmethod();
                        },
                        icon: Icon(
                          Icons.power_settings_new_outlined,
                          color: Colors.white,
                        )),
                  ]
                : []),
        body: ListView.builder(
            itemCount: info.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image(image: AssetImage(iconList[index])),
                ),
                title: Text(
                  info[index],
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => _patientData.getDataScreen(
                              index, widget.patientId,
                              userId: userId)));
                },
              ));
            }));
  }
}
