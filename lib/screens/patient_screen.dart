import 'package:careconnect/components/loading.dart';
import 'package:careconnect/screens/medical_info.dart';
import 'package:careconnect/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';

class PatientHome extends StatefulWidget {
  final String email;
  PatientHome({Key key, this.email}) : super(key: key);

  @override
  _PatientHomeState createState() => _PatientHomeState(this.email);
}

class _PatientHomeState extends State<PatientHome> {
  String email;
  _PatientHomeState(this.email);
  AuthService auth = AuthService();
  PatientData patient = PatientData();
  String documentId;

  @override
  void initState() {
    super.initState();
    patient.getDocsId(email).then((value) {
      setState(() {
        documentId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return documentId != null
        ? MedicalScreen(
            patientId: documentId,
            patientScreen: true,
          )
        : LoadingHeart();
  }
}
