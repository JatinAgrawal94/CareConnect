import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:io';

class GeneralFunctions {
  String host = "https://careconnect-api.herokuapp.com";

  Future<String> getProfileImageURL(String userId) async {
    try {
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/$userId')
          .getDownloadURL();
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  Future deleteProfileImageURL(
      String documentId, String userId, String collection) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/$userId')
          .delete();
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .update({'profileImageURL': null});
      return 1;
    } catch (e) {
      print("Error deleting Image");
      return 0;
    }
  }

  Future uploadProfileImage(File filePath, String filename) async {
    try {
      if (filePath != null) {
        await firebase_storage.FirebaseStorage.instance
            .ref('profile_images/$filename')
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

  Future getDocsId(String email, String collection) async {
    var path = collection.toLowerCase();
    var url = Uri.parse('$host/$path/getdocsid?email=$email&role=$collection');
    var response = await http.get(url);
    var data = jsonDecode(response.body)[0];
    return {
      "documentId": data['documentid'],
      "userId": data['userid'],
      "phoneno": data['phoneno']
    };
  }

  Future getUserInfo(String documentid, String collection) async {
    var path = collection.toLowerCase();
    var url =
        Uri.parse('$host/$path/info?documentid=$documentid&role=$collection');
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<void> updateUserinfo(documentId, data, String collection) async {
    try {
      var role = collection.toLowerCase();
      var url = Uri.parse('$host/$role/update');
      var userData = jsonEncode(data);
      await http.post(url, body: {
        'documentid': documentId,
        'data': userData,
        'collection': collection
      });
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future getAllUser(String collection) async {
    try {
      var role = collection.toLowerCase();
      var url = Uri.parse('$host/$role/all$role');
      var response = await http.get(url);
      List data = jsonDecode(response.body);
      return data;
    } catch (err) {
      return null;
    }
  }
}
