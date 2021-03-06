import 'dart:io';
import 'package:careconnect/screens/medicaldata/Appointment.dart';
import 'package:careconnect/screens/medicaldata/about_screen.dart';
import 'package:careconnect/screens/medicaldata/allergy_screen.dart';
import 'package:careconnect/screens/medicaldata/blood_glucose.dart';
import 'package:careconnect/screens/medicaldata/blood_pressure.dart';
import 'package:careconnect/screens/medicaldata/examination.dart';
import 'package:careconnect/screens/medicaldata/family_history.dart';
import 'package:careconnect/screens/medicaldata/labtest.dart';
import 'package:careconnect/screens/medicaldata/medical_visit.dart';
import 'package:careconnect/screens/medicaldata/notes.dart';
import 'package:careconnect/screens/medicaldata/pathology.dart';
import 'package:careconnect/screens/medicaldata/radiology.dart';
import 'package:careconnect/screens/medicaldata/surgery.dart';
import 'package:careconnect/screens/medicaldata/vaccine.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careconnect/screens/medicaldata/prescription.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:image_picker/image_picker.dart';

class PatientData {
  // keys to map correct data on aboutpage.
  static PickedFile media;

  PickedFile get getMedia {
    return PatientData.media;
  }

  set setMedia(value) {
    PatientData.media = value;
  }

  final patientInfoKeys = {
    0: 'name',
    1: 'userid',
    2: 'email',
    3: 'dateofbirth',
    4: 'gender',
    5: 'bloodgroup',
    6: 'phoneno',
    7: 'insuranceno',
    8: 'address'
  };

// widget to decide which page to route on medicaldata screen.
  Widget getDataScreen(int index, String patientId, {String userId}) {
    if (index == 0) {
      return AboutScreen(
        patientId: patientId,
      );
    } else if (index == 1) {
      return AllergyScreen(
        patientId: patientId,
      );
    } else if (index == 2) {
      return BloodGlucoseScreen(patientId: patientId);
    } else if (index == 3) {
      return BloodPressureScreen(patientId: patientId);
    } else if (index == 4) {
      return ExaminationScreen(patientId: patientId, userId: userId);
    } else if (index == 5) {
      return FamilyHistoryScreen(patientId: patientId);
    } else if (index == 6) {
      return LabTestScreen(patientId: patientId);
    } else if (index == 7) {
      return MedicalVisitScreen(patientId: patientId);
    } else if (index == 8) {
      return NotesScreen(patientId: patientId);
    } else if (index == 9) {
      return PathologyScreen(patientId: patientId);
    } else if (index == 10) {
      return PrescriptionScreen(patientId: patientId);
    } else if (index == 11) {
      return RadiologyScreen(patientId: patientId);
    } else if (index == 12) {
      return SurgeryScreen(patientId: patientId);
    } else if (index == 13) {
      return VaccineScreen(patientId: patientId);
    } else {
      return Appointment(patientId: patientId);
    }
  }

// Reading Data for About Page,medicaldata/about_screen.dart
//

  Future getNoOfPatients() async {
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

  Future increementNoOfPatients(documentid, noofpatients) async {
    await FirebaseFirestore.instance
        .collection('stats')
        .doc(documentid)
        .update({'noofpatients': noofpatients});
  }

  Future getPatientInfo(dynamic patientid) async {
    var data = Map<String, dynamic>();
    await FirebaseFirestore.instance
        .collection('Patient')
        .doc(patientid)
        .get()
        .then((DocumentSnapshot snapshot) {
      data = snapshot.data();
    });
    return data;
  }

  Future getDoctorInfo(dynamic doctorid) async {
    var data = Map<String, dynamic>();
    await FirebaseFirestore.instance
        .collection('Patient')
        .doc(doctorid)
        .get()
        .then((DocumentSnapshot snapshot) {
      data = snapshot.data();
    });
    return data;
  }

// update patientinfo
  Future<void> updatePatientinfo(patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient');
    return await patient
        .doc(patientId)
        .update({
          'name': data['name'],
          'email': data['email'],
          'dateofbirth': data['dateofbirth'],
          'gender': data['gender'],
          'bloodgroup': data['bloodgroup'],
          'phoneno': data['phoneno'],
          'insuranceno': data['insuranceno'],
          'address': data['address']
        })
        .then((value) {})
        .catchError((error) {});
  }

  Future getAllergyData(String patientid) async {
    List test = [];
    await FirebaseFirestore.instance
        .collection('Patient/$patientid/allergy')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        test.add({'type': element['type'], 'date': element['date']});
      });
    });
    return test;
  }

  Future addAllergyData(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/allergy');
    await patient.add({'type': data['type'], 'date': data['date']});
  }

  Future addFamilyHistory(String patientId, data) async {
    CollectionReference patient = FirebaseFirestore.instance
        .collection('Patient/$patientId/familyhistory');
    await patient
        .add({'name': data['name'], 'description': data['description']});
  }

  Future addVaccine(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/vaccine');
    await patient.add({'vaccine': data['vaccine'], 'date': data['date']});
  }

  Future addNotes(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/notes');
    await patient
        .add({'title': data['title'], 'description': data['description']});
  }

  Future addPathologyData(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/pathology');
    await patient.add({
      'title': data['title'],
      'result': data['result'],
      'doctor': data['doctor'],
      'date': data['date'],
      'place': data['place']
    });
  }

  Future addAppointment(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/appointment');
    await patient.add({
      'notes': data['notes'],
      'time': data['time'],
      'doctor': data['doctor'],
      'date': data['date'],
      'place': data['place'],
      'visitType': data['visitType']
    });
  }

  Future addRadiologyData(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/radiology');
    await patient.add({
      'title': data['title'],
      'result': data['result'],
      'doctor': data['doctor'],
      'date': data['date'],
      'place': data['place']
    });
  }

  Future addSurgeryData(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/surgery');
    await patient.add({
      'title': data['title'],
      'result': data['result'],
      'doctor': data['doctor'],
      'date': data['date'],
      'place': data['place']
    });
  }

  Future addBloodGlucose(String patientId, data) async {
    CollectionReference patient = FirebaseFirestore.instance
        .collection('Patient/$patientId/bloodglucose');
    await patient.add({
      'type': data['type'],
      'result': data['result'],
      'resultUnit': data['resultUnit'],
      'date': data['date'],
      'time': data['time']
    });
  }

  Future addPrescription(String patientId, data) async {
    CollectionReference patient = FirebaseFirestore.instance
        .collection('Patient/$patientId/prescription');
    await patient.add({
      'drug': data['drug'],
      'dose': data['dose'],
      'doctor': data['doctor'],
      'place': data['place'],
    });
  }

  Future addMedicalVisit(String patientId, data) async {
    CollectionReference patient = FirebaseFirestore.instance
        .collection('Patient/$patientId/medicalvisit');
    await patient.add({
      'visitType': data['visitType'],
      'doctor': data['doctor'],
      'place': data['place'],
      'date': data['date'],
    });
  }

  Future addLabTest(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/labtest');
    await patient.add({
      'test': data['test'],
      'result': data['result'],
      'normal': data['normal'],
      'doctor': data['doctor'],
      'place': data['place'],
      'date': data['date'],
    });
  }

  Future addBloodPressure(String patientId, data) async {
    CollectionReference patient = FirebaseFirestore.instance
        .collection('Patient/$patientId/bloodpressure');
    await patient.add({
      'systolic': data['systolic'],
      'diastolic': data['diastolic'],
      'pulse': data['pulse'],
      'date': data['date'],
      'time': data['time']
    });
  }

  Future addExamination(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/examination');
    await patient.add({
      'temperature': data['temperature'],
      'weight': data['weight'],
      'height': data['height'],
      'symptoms': data['symptoms'],
      'diagnosis': data['diagnosis'],
      'notes': data['notes'],
      'doctor': data['doctor'],
      'place': data['place'],
      'date': data['date'],
    });
  }

  Future<void> uploadFile(File filePath, String filename) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/P$filename.png')
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

  Future<void> uploadPatientPhoto(
      File filepath, String date, String category, String userId) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('Patient/$userId/photo/$category/$date.png')
          .putFile(filepath);
      print("File Uploaded Successfully");
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> uploadPatientVideo(
      File filepath, String date, String category, String userId) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('Patient/$userId/video/$category/$date.mp4')
          .putFile(filepath);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> uploadPatientFile(
      File filepath, String date, String category, String userId) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('Patient/$userId/file/$category/$date.pdf')
          .putFile(filepath);
      print("File Uploaded Successfully");
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  _imgfromCamera() async {
    ImagePicker picker = ImagePicker();
    final pickerfile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    PatientData.media = pickerfile;
  }

  _imgfromgallery() async {
    ImagePicker picker = ImagePicker();
    final galleryimage =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    PatientData.media = galleryimage;
  }

  void showpicker(context) {
    PatientData patient = PatientData();
    var image = showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
                  child: Wrap(children: <Widget>[
            ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("PhotoGallery"),
                onTap: () async {
                  patient._imgfromgallery();
                  Navigator.of(context).pop();
                }),
            ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text("Camera"),
                onTap: () {
                  patient._imgfromCamera();
                  Navigator.of(context).pop();
                }),
          ])));
        });
  }

  Future<String> getProfileImageURL(String userId) async {
    try {
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/$userId.png')
          .getDownloadURL();
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  Future addPatient(data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient');
    await patient
        .add({
          'name': data['name'],
          'email': data['email'],
          'dateofbirth': data['dateofbirth'],
          'gender': data['gender'],
          'bloodgroup': data['bloodgroup'],
          'phoneno': data['phoneno'],
          'insuranceno': data['insuranceno'],
          'address': data['address'],
          'userid': data['userid']
        })
        .then((value) {})
        .catchError((error) {});

    await FirebaseFirestore.instance.collection('users').add(
        {'email': data['email'], 'role': 'patient', 'userid': data['userid']});
  }

  Future getDocsId(String email) async {
    var id;
    print("$email in getDocsId");
    await FirebaseFirestore.instance
        .collection('Patient')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        id = element.id;
      });
    });
    return id;
  }

// yet to be configured not ready to be used
  Future deletePatient(String patientId, String userId) async {
    var id;
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient');
    await patient
        .doc(patientId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));

    CollectionReference user = FirebaseFirestore.instance.collection('user');

    await user
        .where('userid', isEqualTo: userId)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        id = element.id;
      });
    });

    user.doc(id).delete().then((value) {
      print("Patient Deleted");
    }).catchError((error) => print(error));
  }

  Future getPatientUserId(String patientId) async {
    CollectionReference user = FirebaseFirestore.instance.collection('Patient');
    String userId;
    user
        .where('userid', isEqualTo: userId)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        userId = element['userid'];
      });
    });
    return userId;
  }
}
