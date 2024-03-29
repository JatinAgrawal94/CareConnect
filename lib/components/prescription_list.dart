import 'package:careconnect/components/photogrid.dart';
import 'package:careconnect/services/patientdata.dart';
import 'package:flutter/material.dart';

class PrescriptionList extends StatefulWidget {
  final String drug;
  final String dose;
  final String doctor;
  final String date;
  final List timing;
  final String patientId;
  final String prescriptionId;
  final dynamic media;
  final String role;
  final String approved;
  PrescriptionList(
      {Key key,
      this.drug,
      this.dose,
      this.doctor,
      this.date,
      this.timing,
      this.patientId,
      this.prescriptionId,
      this.media,
      this.role,
      this.approved})
      : super(key: key);

  @override
  _PrescriptionListState createState() => _PrescriptionListState(
      this.drug,
      this.dose,
      this.doctor,
      this.date,
      this.timing,
      this.patientId,
      this.prescriptionId,
      this.media,
      this.role,
      this.approved);
}

class _PrescriptionListState extends State<PrescriptionList> {
  final String drug;
  final String dose;
  final String doctor;
  final String date;
  final dynamic media;
  final List timing;
  final String patientId;
  final String prescriptionId;
  final String role;
  final String approved;
  PatientData _patient = PatientData();
  _PrescriptionListState(
      this.drug,
      this.dose,
      this.doctor,
      this.date,
      this.timing,
      this.patientId,
      this.prescriptionId,
      this.media,
      this.role,
      this.approved);

  PatientData _patientData = PatientData();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          color: approved == 'false' ? Colors.grey[200] : Colors.white,
        ),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$drug",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "$dose",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Doctor:$doctor",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Timings:  " +
                        timing[0] +
                        " - " +
                        timing[1] +
                        " - " +
                        timing[2],
                    style: TextStyle(fontSize: 16),
                  ),
                  (media['images'].length == 0 &&
                          media['videos'].length == 0 &&
                          media['files'].length == 0)
                      ? Text("")
                      : RawMaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PhotoGrid(
                                          image: media['images'],
                                          video: media['videos'],
                                          file: media['files'],
                                          filetype: "record",
                                        )));
                          },
                          fillColor: Colors.deepPurple,
                          splashColor: Colors.white,
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "View",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_right,
                                size: 20,
                                color: Colors.white,
                              )
                            ],
                          )),
                        ),
                ],
              ),
              Column(children: <Widget>[
                Container(
                  child: IconButton(
                    iconSize: 30,
                    color: Colors.deepPurple,
                    icon: Icon(Icons.notification_add),
                    onPressed: () {},
                  ),
                ),
                Container(
                  child: IconButton(
                    iconSize: 30,
                    color: Colors.deepPurple,
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await _patient.deleteAnyPatientRecord(
                          patientId, prescriptionId, 'prescription');
                    },
                  ),
                )
              ])
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              role == "patient" || role == null
                  ? Container(
                      child: (approved == 'false'
                          ? Text(
                              "Waiting for Approval",
                              style: TextStyle(color: Colors.grey),
                            )
                          : Text(
                              "Approved",
                              style: TextStyle(color: Colors.green),
                            )))
                  : Container(
                      child: ElevatedButton(
                          onPressed: () async {
                            await _patientData.updateApprovalStatus(patientId,
                                prescriptionId, 'prescription', approved);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: approved == 'false'
                                  ? Colors.green
                                  : Colors.red),
                          child: approved == 'false'
                              ? Text("Verify")
                              : Text("Unverify")))
            ],
          )
        ]));
  }
}
