import 'package:careconnect/components/medical_info.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:flutter/material.dart';

class PatientListTile extends StatefulWidget {
  final String name;
  final String userId;
  final String documentId;
  PatientListTile({Key key, this.name, this.userId, this.documentId})
      : super(key: key);

  @override
  State<PatientListTile> createState() =>
      _PatientListTileState(this.name, this.userId, this.documentId);
}

class _PatientListTileState extends State<PatientListTile> {
  PatientData _patientData = PatientData();
  String name;
  String userId;
  String documentId;
  String image;
  _PatientListTileState(this.name, this.userId, this.documentId);
  @override
  void initState() {
    super.initState();
    _patientData.getProfileImageURL(userId).then((value) {
      if (this.mounted) {
        setState(() {
          image = value;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: image == null
            ? Icon(Icons.person, size: 40)
            : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  image,
                  width: 55,
                  height: 55,
                  fit: BoxFit.fill,
                ),
              ),
        title: new Text(
          name,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: new Text("Patient Id: " + userId),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MedicalScreen(patientId: documentId, userId: userId)));
        },
      ),
      decoration: BoxDecoration(border: Border.all(width: 0.3)),
    );
  }
}
