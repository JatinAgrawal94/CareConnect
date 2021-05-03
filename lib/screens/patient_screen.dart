import 'package:careconnect/components/loading.dart';
import 'package:careconnect/models/registereduser.dart';
import 'package:careconnect/screens/medical_info.dart';
import 'package:careconnect/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:provider/provider.dart';

class PatientHome extends StatefulWidget {
  PatientHome({Key key}) : super(key: key);

  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  AuthService auth = AuthService();
  PatientData patient = PatientData();
  var user;
  var email;
  var documentId;

  @override
  void initState() {
    super.initState();
    patient.getDocsId(email).then((value) {
      setState(() {
        documentId = value;
      });
    });
  }

  void getEmail(value) {
    setState(() {
      this.email = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<RegisteredUser>(context);
    getEmail(user.emailGet);
    return documentId != null
        ? MedicalScreen(
            patientId: documentId,
            patientScreen: true,
          )
        : LoadingHeart();
  }
}
