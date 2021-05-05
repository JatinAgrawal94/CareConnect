import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';

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
    7: 'contact',
    8: 'address'
  };

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
          'userid': data['userid']
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
          'address': data['address']
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
}
