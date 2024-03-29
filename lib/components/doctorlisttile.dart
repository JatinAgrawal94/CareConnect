import 'package:careconnect/screens/doctor_medical_screen.dart';
import 'package:flutter/material.dart';

class DoctorListTile extends StatefulWidget {
  final String name;
  final String userId;
  final String documentId;
  final String profileImageURL;
  final String email;
  DoctorListTile(
      {Key key,
      this.name,
      this.userId,
      this.documentId,
      this.profileImageURL,
      this.email})
      : super(key: key);

  @override
  State<DoctorListTile> createState() => _DoctorListTileState(this.name,
      this.userId, this.documentId, this.profileImageURL, this.email);
}

class _DoctorListTileState extends State<DoctorListTile> {
  String name;
  String userId;
  String documentId;
  String image;
  String email;
  final String profileImageURL;
  _DoctorListTileState(this.name, this.userId, this.documentId,
      this.profileImageURL, this.email);
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
        subtitle: new Text("Doctor Id: " + userId),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DoctorInfo(
                        documentId: documentId,
                        email: email,
                      )));
        },
      ),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.3))),
    );
  }
}
