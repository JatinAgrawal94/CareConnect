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
import 'package:video_thumbnail/video_thumbnail.dart';

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
      return LabTestScreen(patientId: patientId, userId: userId);
    } else if (index == 7) {
      return MedicalVisitScreen(patientId: patientId);
    } else if (index == 8) {
      return NotesScreen(patientId: patientId, userId: userId);
    } else if (index == 9) {
      return PathologyScreen(patientId: patientId, userId: userId);
    } else if (index == 10) {
      return PrescriptionScreen(patientId: patientId, userId: userId);
    } else if (index == 11) {
      return RadiologyScreen(
        patientId: patientId,
        userId: userId,
      );
    } else if (index == 12) {
      return SurgeryScreen(patientId: patientId, userId: userId);
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

  Future getPatientIdByEmail(String email) async {
    List data = [];
    await FirebaseFirestore.instance
        .collection('Patient')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        data.add({'userid': element['userid'], 'phone': element['phoneno']});
      });
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
          'address': data['address'],
          'profileImageURL': data['profileImageURL']
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
    await patient
        .add({'type': data['type'], 'date': data['date'], 'delete': 0});
  }

  Future addFamilyHistory(String patientId, data) async {
    CollectionReference patient = FirebaseFirestore.instance
        .collection('Patient/$patientId/familyhistory');
    await patient.add({
      'name': data['name'],
      'description': data['description'],
      'delete': 0
    });
  }

  Future addVaccine(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/vaccine');
    await patient.add({
      'vaccine': data['vaccine'],
      'date': data['date'],
      'place': data['place'],
      'delete': 0
    });
  }

  Future addNotes(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/notes');
    await patient.add({
      'title': data['title'],
      'description': data['description'],
      'media': data['media'],
      'delete': 0
    });
  }

  Future addPathologyData(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/pathology');
    await patient.add({
      'title': data['title'],
      'result': data['result'],
      'doctor': data['doctor'],
      'date': data['date'],
      'place': data['place'],
      'media': data['media'],
      'delete': 0
    });
  }

  Future addAppointment(String patientId, data) async {
    String zoom;

    var offline = {
      'reason': data['reason'],
      'date': data['date'],
      'timing': data['timing'],
      'doctorname': data['doctorname'],
      'doctoremail': data['doctoremail'],
      'patientname': data['patientname'],
      'patientemail': data['patientemail'],
      'visittype': data['visittype'],
      'appointmenttype': data['appointmenttype'],
      'paymentstatus': data['paymentstatus'],
      'paymentamount': data['paymentamount'],
      'delete': 0
    };

    if (data['appointmenttype'] == 'Online') {
      await FirebaseFirestore.instance
          .collection('Doctor')
          .where('email', isEqualTo: data['doctoremail'])
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((element) {
          zoom = element['zoom'];
        });
      });
      CollectionReference appointment =
          FirebaseFirestore.instance.collection('Appointment');
      await appointment.add({
        'reason': data['reason'],
        'date': data['date'],
        'timing': data['timing'],
        'doctorname': data['doctorname'],
        'doctoremail': data['doctoremail'],
        'patientname': data['patientname'],
        'patientemail': data['patientemail'],
        'visittype': data['visittype'],
        'appointmenttype': data['appointmenttype'],
        'paymentstatus': data['paymentstatus'],
        'paymentamount': data['paymentamount'],
        'zoom': zoom,
        'delete': 0
      });
    } else {
      CollectionReference appointment =
          FirebaseFirestore.instance.collection('Appointment');
      await appointment.add(offline);
    }
  }

  Future addRadiologyData(String patientId, data) async {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patient/$patientId/radiology');
    await patient.add({
      'title': data['title'],
      'result': data['result'],
      'doctor': data['doctor'],
      'date': data['date'],
      'place': data['place'],
      'media': data['media'],
      'delete': 0
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
      'place': data['place'],
      'media': data['media'],
      'delete': 0
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
      'time': data['time'],
      'delete': 0
    });
  }

  Future addPrescription(String patientId, data) async {
    CollectionReference patient = FirebaseFirestore.instance
        .collection('Patient/$patientId/prescription');
    await patient.add({
      'drug': data['drug'],
      'dose': data['dose'],
      'doctor': data['doctor'],
      'date': data['date'],
      'timing': data['timings'],
      'place': data['place'],
      'media': data['media'],
      'delete': 0
    });
  }

  Future deleteAnyPatientRecord(patientId, recordId, category) async {
    // patient documentId, prescription docuementId
    FirebaseFirestore.instance
        .collection('Patient/$patientId/$category')
        .doc(recordId)
        .delete()
        .then((value) => print("$category record Deleted"))
        .catchError((error) => print("Failed to delete prescription: $error"));
  }

  Future addMedicalVisit(String patientId, data) async {
    CollectionReference patient = FirebaseFirestore.instance
        .collection('Patient/$patientId/medicalvisit');
    await patient.add({
      'visitType': data['visitType'],
      'doctor': data['doctor'],
      'place': data['place'],
      'date': data['date'],
      'delete': 0
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
      'media': data['media'],
      'delete': 0
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
      'time': data['time'],
      'delete': 0
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
      'media': data['media'],
      'delete': 0
    });
  }

  Future uploadFile(File filePath, String filename) async {
    try {
      if (filePath != null) {
        await firebase_storage.FirebaseStorage.instance
            .ref('profile_images/P$filename.png')
            .putFile(filePath);
        var url = await getProfileImageURL(filename);
        print("File Uploaded Successfully");
        return url;
      } else {
        return null;
      }
    } on firebase_core.FirebaseException catch (e) {
      print(e);
      return 0;
    }
  }

  Future updateFile(File filePath, String filename) async {
    try {
      if (filePath != null) {
        await firebase_storage.FirebaseStorage.instance
            .ref('profile_images/$filename.png')
            .putFile(filePath);
        var url = await getProfileImageURL(filename);
        print("File Uploaded Successfully");
        return url;
      } else {
        return null;
      }
    } on firebase_core.FirebaseException catch (e) {
      print(e);
      return 0;
    }
  }

  Future<void> uploadPatientPhoto(
      File filepath, String name, String category, String userId) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('Patient/$userId/$category/images/$name')
          .putFile(filepath);
      print("File Uploaded Successfully");
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<List<dynamic>> prepareFiles(List test) async {
    var data = [];
    for (var i = 0; i < test.length; i++) {
      data.add({
        'filename': File(test[i]),
        'name': getName(File(test[i]).toString())
      });
    }
    return data;
  }

  String getName(String filename) {
    List temp = filename.split('/');
    temp = temp[temp.length - 1].split('\'');
    return temp[0];
  }

  Future uploadMediaFiles(test, category, userId) async {
    var a;
    String url;
    var images = [];
    var videos = [];
    var files = [];

    if (test['image'].length != 0) {
      a = test['image'];
      for (var i = 0; i < a.length; i++) {
        await uploadPatientPhoto(
            a[i]['filename'], a[i]['name'], category, userId);
      }
      for (var i = 0; i < a.length; i++) {
        url = await getMediaURL(userId, category, 'images', a[i]['name']);
        print(url);
        images.add({'name': a[i]['name'], 'url': url});
      }
    }

    if (test['video'].length != 0) {
      a = test['video'];
      for (var i = 0; i < a.length; i++) {
        await uploadPatientVideo(
            a[i]['filename'], a[i]['name'], category, userId);
      }
      for (var i = 0; i < a.length; i++) {
        url = await getMediaURL(userId, category, 'videos', a[i]['name']);
        videos.add({'name': a[i]['name'], 'url': url});
      }
    }

    if (test['file'].length != 0) {
      a = test['file'];
      for (var i = 0; i < a.length; i++) {
        await uploadPatientFile(
            a[i]['filename'], a[i]['name'], category, userId);
      }
      for (var i = 0; i < a.length; i++) {
        url = await getMediaURL(userId, category, 'files', a[i]['name']);
        files.add({'name': a[i]['name'], 'url': url});
      }
    }

    var media = {'images': images, 'videos': videos, 'files': files};
    return media;
    // saveMediaURL(patientId, category, categoryDocumentId, filename);
  }

  Future saveMediaURL(
      String patientId, String category, String categoryDocumentId) async {
    await FirebaseFirestore.instance
        .collection('Patient/$patientId/$category')
        .doc(categoryDocumentId)
        .update({
      'media': {'images'}
    });
  }

  Future<void> uploadPatientVideo(
      File filepath, String name, String category, String userId) async {
    try {
      String t = 'Patient/$userId/$category/videos/$name';
      await firebase_storage.FirebaseStorage.instance.ref(t).putFile(filepath);
      print("File Uploaded Successfully");
    } on firebase_core.FirebaseException catch (e) {
      print("This is an exception");
      print(e);
    }
  }

  Future<void> uploadPatientFile(
      File filepath, String name, String category, String userId) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('Patient/$userId/$category/files/$name')
          .putFile(filepath);
      print("File Uploaded Successfully");
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future getMediaURL(
      String userId, String category, String filetype, String filename) async {
    // files
    try {
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('Patient/$userId/$category/$filetype/$filename')
          .getDownloadURL();
      return downloadURL;
    } catch (err) {
      return 0;
    }
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

  Future deleteProfileImageURL(String patientId, String userId) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/$userId.png')
          .delete();
      await FirebaseFirestore.instance
          .collection('Patient')
          .doc(patientId)
          .update({'profileImageURL': null});
      return 1;
    } catch (e) {
      print("Error deleting Image");
      return 0;
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
          'userid': data['userid'],
          'profileImageURL':data['profileImageURL']
        })
        .then((value) {})
        .catchError((error) {});

    await FirebaseFirestore.instance.collection('users').add(
        {'email': data['email'], 'role': 'patient', 'userid': data['userid']});
  }

  Future getDocsId(String email) async {
    var id;
    var userId;
    await FirebaseFirestore.instance
        .collection('Patient')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        id = element.id;
        userId = element['userid'];
      });
    });
    return {"documentId": id, "userId": userId};
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

  Future getVideoThumbnail(video) async {
    List thumb = [];
    var test;
    for (var i = 0; i < video.length; i++) {
      test = await VideoThumbnail.thumbnailData(
        video: video[i]['filename'].path,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      thumb.add(test);
    }
    return thumb;
  }
}
