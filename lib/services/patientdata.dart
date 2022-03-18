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
import 'package:careconnect/screens/medicaldata/prescription.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;

class PatientData {
  // keys to map correct data on aboutpage.
  static PickedFile media;
  String host = "https://careconnect-api.herokuapp.com";
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

  Future getCategoryData(String category, String documentid) async {
    try {
      category = category.toLowerCase();
      var url = Uri.parse('$host/patient/$category/all?documentid=$documentid');
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      return data;
    } catch (err) {
      return null;
    }
  }

  Future deleteAppointment(String documentid) async {
    try {
      var body = {'documentid': documentid};
      var url = Uri.parse('$host/appointment/delete');
      var response = await http.post(url, body: body);
      return response.body;
    } catch (e) {
      return null;
    }
  }

  Future checkUserValidityForAppointment(
      String doctoremail, String patientemail, String date) async {
    try {
      var body = {
        'doctoremail': doctoremail,
        'patientemail': patientemail,
        'date': date
      };
      var url = Uri.parse('$host/appointment/check');
      var response = await http.post(url, body: body);
      return int.parse(response.body);
    } catch (err) {
      return null;
    }
  }

  Future addAppointment(String patientId, data) async {
    try {
      var url = Uri.parse('$host/appointment/create');
      await http.post(url, body: data);
    } catch (err) {
      return null;
    }
  }

  Future deleteAnyPatientRecord(patientId, recordId, category) async {
    // patient documentId, prescription docuementId
    try {
      var body = {
        'patientid': patientId,
        'recordid': recordId,
        'category': category
      };
      var url = Uri.parse('$host/patient/record/delete');
      await http.post(url, body: body);
    } catch (err) {
      print("Failed to delete $category record: $err");
    }
  }

  Future getPatientAppointments(String email) async {
    try {
      var url = Uri.parse('$host/appointment/patient?email=$email');
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      return data;
    } catch (err) {
      return null;
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
