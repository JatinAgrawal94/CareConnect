import 'package:careconnect/components/medical_info.dart';
import 'package:flutter/material.dart';

class PatientListTile extends StatefulWidget {
  final String name;
  final String userId;
  final String documentId;
  final String profileImageURL;
  PatientListTile(
      {Key key, this.name, this.userId, this.documentId, this.profileImageURL})
      : super(key: key);

  @override
  State<PatientListTile> createState() => _PatientListTileState(
      this.name, this.userId, this.documentId, this.profileImageURL);
}

class _PatientListTileState extends State<PatientListTile> {
  String name;
  String userId;
  String documentId;
  String image;
  String profileImageURL;
  _PatientListTileState(
      this.name, this.userId, this.documentId, this.profileImageURL);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: profileImageURL == null
            ? Icon(Icons.person, size: 40)
            : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  profileImageURL,
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
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.3))),
    );
  }
}
