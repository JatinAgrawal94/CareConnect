import 'dart:io';
import 'package:careconnect/screens/medicaldata/doctor_appointment.dart';
import 'package:careconnect/screens/userdataforms/doctor_profile.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DoctorData {
  static String doctorId;
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

  Future getAllDoctors() async {
    List data = [];
    await FirebaseFirestore.instance
        .collection('Doctor')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        data.add({
          "name": element['name'],
          'timing': element['timing'],
          'email': element['email']
        });
      });
    });
    return data;
  }

  Future getDoctorInfo(String doctorid) async {
    var data = Map<String, dynamic>();
    await FirebaseFirestore.instance
        .collection('Doctor')
        .doc(doctorid)
        .get()
        .then((DocumentSnapshot snapshot) {
      data = snapshot.data();
    });
    return data;
  }

  Future addDoctor(data) async {
    CollectionReference doctor =
        FirebaseFirestore.instance.collection('Doctor');
    await doctor
        .add({
          'name': data['name'],
          'email': data['email'],
          'dateofbirth': data['dateofbirth'],
          'gender': data['gender'],
          'bloodgroup': data['bloodgroup'],
          'contact': data['contact'],
          'address': data['address'],
          'designation': data['designation'],
          'userid': data['userid'],
          'doctype': data['doctype'],
          'zoom': " "
        })
        .then((value) {})
        .catchError((error) {
          print(error);
        });
    FirebaseFirestore.instance.collection('users').add(
        {'email': data['email'], 'role': 'doctor', 'userid': data['userid']});
  }

  Future<String> getProfileImageURL(String doctorId) async {
    try {
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/$doctorId.png')
          .getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error retrieving image");
      return null;
    }
  }

  Future deleteProfileImageURL(String doctorId) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/$doctorId.png')
          .delete();
      return 1;
    } catch (e) {
      print(e);
      print("Error deleting Image");
      return 0;
    }
  }

  Future<void> uploadFile(File filePath, String filename) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/D$filename.png')
          .putFile(filePath);
      print("File Uploaded Successfully");
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> updateFile(File filePath, String filename) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/$filename.png')
          .putFile(filePath);
      print("File Uploaded Successfully");
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> updateDoctorinfo(doctorId, data) async {
    CollectionReference doctor =
        FirebaseFirestore.instance.collection('Doctor');
    return await doctor
        .doc(doctorId)
        .update({
          'name': data['name'],
          'email': data['email'],
          'dateofbirth': data['dateofbirth'],
          'gender': data['gender'],
          'bloodgroup': data['bloodgroup'],
          'contact': data['contact'],
          'designation': data['designation'],
          'address': data['address'],
          'doctype': data['doctype']
        })
        .then((value) {})
        .catchError((error) {});
  }

  Future getNoOfDoctors() async {
    List data = [];
    await FirebaseFirestore.instance
        .collection('stats')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        data.add({
          'noofpatients': element['noofpatients'],
          'noofdoctors': element['noofdoctors'],
          'documentid': element.id
        });
      });
    });
    return data;
  }

  Future increementNoOfDoctors(documentid, noofdoctors) async {
    await FirebaseFirestore.instance
        .collection('stats')
        .doc(documentid)
        .update({'noofdoctors': noofdoctors});
  }

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

  Future getDocsId(String email) async {
    var id;
    await FirebaseFirestore.instance
        .collection('Doctor')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        id = element.id;
      });
    });
    return id;
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
    var info = await getDoctorInfo(doctorId);
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

  // Future deleteAppointment(String documentId) async {
  //   FirebaseFirestore.instance
  //       .collection('Appointment')
  //       .where('doctoremail', isEqualTo: doctoremail)
  //       .where('date', isEqualTo: date);
  // }
}
