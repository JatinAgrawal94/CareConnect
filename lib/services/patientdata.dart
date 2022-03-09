import 'dart:convert';
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
import 'package:http/http.dart' as http;

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

  Future getPatientInfo(dynamic documentid) async {
    try {
      var url = Uri.parse(
          'https://careconnect-api.herokuapp.com/patient/info?documentid=$documentid');
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      return data;
    } catch (err) {
      print(err);
      return null;
    }
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

  Future addMedicalData(String patientId, String category, data) async {
    try {
      var url = Uri.parse(
          'https://careconnect-api.herokuapp.com/patient/$category/create');
      await http
          .post(url, body: {"patientId": patientId, "data": jsonEncode(data)});
    } catch (err) {
      print(err);
    }
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

  Future deleteAnyPatientRecord(patientId, recordId, category) async {
    // patient documentId, prescription docuementId
    FirebaseFirestore.instance
        .collection('Patient/$patientId/$category')
        .doc(recordId)
        .delete()
        .then((value) => print("$category record Deleted"))
        .catchError((error) => print("Failed to delete prescription: $error"));
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
          'profileImageURL': data['profileImageURL']
        })
        .then((value) {})
        .catchError((error) {});

    await FirebaseFirestore.instance.collection('users').add(
        {'email': data['email'], 'role': 'patient', 'userid': data['userid']});
  }

  Future getDocsId(String email) async {
    var url = Uri.parse(
        'https://careconnect-api.herokuapp.com/patient/getdocsid?email=$email');
    var response = await http.get(url);
    var data = jsonDecode(response.body)[0];
    return {
      "documentId": data['documentid'],
      "userId": data['userid'],
      "phoneno": data['phoneno']
    };
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
