import 'package:careconnect/screens/medicaldata/doctor_appointment.dart';
import 'package:careconnect/screens/userdataforms/doctor_profile.dart';
import 'package:careconnect/services/general.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DoctorData {
  static String doctorId;
  GeneralFunctions general = GeneralFunctions();
  final doctorInfoKeys = {
    0: 'name',
    1: 'userid',
    2: 'email',
    3: 'dateofbirth',
    4: 'gender',
    5: 'bloodgroup',
    6: 'designation',
    7: 'doctype',
    8: "timing",
    9: 'contact',
    10: 'address'
  };

  String convertDate(String date) {
    var g = date.split('/').reversed.toList();
    if (int.parse(g[1]) / 10 < 1) {
      g[1] = "0" + g[1];
    }

    if (int.parse(g[2]) / 10 < 1) {
      g[2] = "0" + g[2];
    }
    return g.join('-').toString();
  }

  Widget getScreen(int index, String doctorId) {
    if (index == 0) {
      return DoctorProfile(doctorId: doctorId);
    } else {
      return DoctorAppointment(
        doctorId: doctorId,
      );
    }
  }

  Future createDoctorAppointment(String doctorId, data) async {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Appointment');
    await appointment.add({
      "date": data["date"],
    });
  }

  Map count(elements) {
    var map = Map();
    elements.forEach((element) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] += 1;
      }
    });
    return map;
  }

  Future getAppointmentDates(String doctorId) async {
    List data = [];
    var date = [];
    var doctoremail = " ";
    List documentId = [];
    var info = await general.getUserInfo(doctorId, 'Doctor');
    doctoremail = info['email'];
    await FirebaseFirestore.instance
        .collection('Appointment')
        .where('doctoremail', isEqualTo: info['email'].toString())
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        data.add({
          'date': element['date'],
          'timing': element['timing'],
          'documentId': element.id
        });
      });
    });
    data.forEach((item) {
      date.add(item['date']);
    });
    data.forEach((item) {
      documentId.add(item['documentId']);
    });

    var dateOccurence = count(date);
    var timing = data[0]['timing'];
    return [date, dateOccurence, timing, doctoremail, documentId];
  }

  Future getPatientsBasedOnDateAndDoctor(
      String doctoremail, String date) async {
    List data = [];
    await FirebaseFirestore.instance
        .collection('Appointment')
        .where('doctoremail', isEqualTo: doctoremail)
        .where('date', isEqualTo: date)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        data.add({
          'patientname': element['patientname'],
          'patientemail': element['patientemail'],
          'reason': element['reason'],
          'visittype': element['visittype'],
          'paymentstatus': element['paymentstatus'],
          'paymentamount': element['paymentamount'],
          'appointmenttype': element['appointmenttype'],
          'docId': element.id
        });
      });
    });
    return data;
  }

  Future getAppointmentId(String doctoremail, String patientemail, String date,
      String paymentstatus) async {
    var id;
    await FirebaseFirestore.instance
        .collection('Appointment')
        .where('doctoremail', isEqualTo: doctoremail)
        .where('patientemail', isEqualTo: patientemail)
        .where('date', isEqualTo: date)
        .where('paymentstatus', isEqualTo: paymentstatus)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        id = element.id;
      });
    });
    return id;
  }

  Future updatePaymentAmount(String doctorEmail, String patientEmail,
      String date, String paymentStatus, String paymentamount) async {
    var docId =
        await getAppointmentId(doctorEmail, patientEmail, date, paymentStatus);
    await FirebaseFirestore.instance
        .collection('Appointment')
        .doc(docId)
        .update({'paymentamount': paymentamount})
        .then((value) {})
        .catchError((error) {});
  }

  Future checkUserValidityForAppointment(
      String doctoremail, String patientemail, String date) async {
    List data = [];
    await FirebaseFirestore.instance
        .collection('Appointment')
        .where('doctoremail', isEqualTo: doctoremail)
        .where('patientemail', isEqualTo: patientemail)
        .where('date', isEqualTo: date)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        if (element != null) {
          data.add(element['patientemail']);
        }
      });
    });
    if (data.length == 1) {
      return 0;
    } else {
      return 1;
    }
  }
}
