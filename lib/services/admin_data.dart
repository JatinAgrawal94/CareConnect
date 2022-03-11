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
          'address': data['address'],
          'profileImageURL': data['profileImageURL']
        })
        .then((value) {})
        .catchError((error) {});
  }
}
