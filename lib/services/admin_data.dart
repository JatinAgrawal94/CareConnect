import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class AdminData {
  final adminInfoKeys = {
    0: 'name',
    1: 'email',
    2: 'dateofbirth',
    3: 'gender',
    4: 'bloodgroup',
    5: 'contact',
    6: 'address'
  };

  Future getDocsId(String email) async {
    var id;
    await FirebaseFirestore.instance
        .collection('Admin')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        id = element.id;
      });
    });
    return id;
  }

  Future getAdminInfo(String adminId) async {
    var data = Map<String, dynamic>();
    await FirebaseFirestore.instance
        .collection('Admin')
        .doc(adminId)
        .get()
        .then((DocumentSnapshot snapshot) {
      data = snapshot.data();
    });
    return data;
  }

  Future<String> getProfileImageURL(String adminId) async {
    try {
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/$adminId.png')
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
          .ref('profile_images/A$filename.png')
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

  Future<void> updateAdmininfo(adminId, data) async {
    CollectionReference admin = FirebaseFirestore.instance.collection('Admin');
    await admin
        .doc(adminId)
        .update({
          'name': data['name'],
          'email': data['email'],
          'dateofbirth': data['dateofbirth'],
          'gender': data['gender'],
          'bloodgroup': data['bloodgroup'],
          'contact': data['contact'],
          'address': data['address']
        })
        .then((value) {})
        .catchError((error) {});
  }
}
