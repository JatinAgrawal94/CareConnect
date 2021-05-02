import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class MedicalScreen extends StatefulWidget {
  final String patientId;
  MedicalScreen({Key key, @required this.patientId}) : super(key: key);

  @override
  _MedicalScreenState createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicalScreen> {
  PatientData _patientData = PatientData();

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
    "Assign Appointment"
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("Medical Data"),
        ),
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
                              index, widget.patientId)));
                },
              ));
            }));
  }
}
