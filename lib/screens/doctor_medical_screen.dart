import 'package:flutter/material.dart';
import 'package:careconnect/services/doctordata.dart';

// page showing options in by clicking on doctor profile button.
class DoctorInfo extends StatefulWidget {
  final String documentId;
  final String email;
  DoctorInfo({Key key, this.documentId, this.email}) : super(key: key);

  @override
  State<DoctorInfo> createState() =>
      _DoctorInfoState(this.documentId, this.email);
}

class _DoctorInfoState extends State<DoctorInfo> {
  final String doctorId;
  final String email;
  DoctorData _doctorData = DoctorData();
  _DoctorInfoState(this.doctorId, this.email);
  List info = ["Personal Information", "Appointments"];
  List images = ['assets/about.png', 'assets/appointment.png'];

  // we need to pass the doctor timing in order to make it
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Doctor Info"),
      ),
      body: ListView.builder(
          itemCount: info.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image(image: AssetImage(images[index]))),
              title: Text(
                info[index],
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            _doctorData.getScreen(index, doctorId, email)));
              },
            ));
          }),
    );
  }
}
