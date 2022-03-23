import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:careconnect/models/registereduser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  String host = "https://careconnect-api.herokuapp.com";
  final storage = FlutterSecureStorage();
  static String userid;

  Future makeHttpRequest(var url, String requestType, {body}) async {
    try {
      // get request
      if (requestType.toLowerCase() == 'get') {
        var response = await http.get(url, headers: await getRequestHeader());
        var data = await jsonDecode(response.body);
        if (data.runtimeType.toString() == 'List<dynamic>') {
          return data;
        } else if (data['message'] == 'auth/id-token-expired') {
          await updateToken();
          response = await http.get(url, headers: await getRequestHeader());
          data = await jsonDecode(response.body);
          return data;
        } else {
          return data;
        }
      }
      // post request
      else {
        var response =
            await http.post(url, headers: await getRequestHeader(), body: body);
        var data = await jsonDecode(response.body);
        if (data['message'] == 'auth/id-token-expired') {
          await updateToken();
          response = await http.post(url,
              headers: await getRequestHeader(), body: body);
          data = await jsonDecode(response.body);
        }
        return data;
      }
    } catch (e) {
      return e;
    }
  }

  Future getRole(String email) async {
    var data = await makeHttpRequest(
        Uri.parse('$host/auth/getrole?email=$email'), 'get');
    return data;
  }

  Future updateToken() async {
    try {
      var token = await auth.currentUser.getIdToken(true);
      storage.write(key: getCurrentUser(), value: token);
      return true;
    } catch (err) {
      return null;
    }
  }

  String getCurrentUser() {
    User user = auth.currentUser;
    return user.email.toString();
  }

  Future getTokenFromStorage(key) async {
    var token = await storage.read(key: key);
    return token;
  }

  // get RegisteredUser(model) format for logged in user.
  RegisteredUser _userFromFirebase(User user) {
    if (user != null) {
      return RegisteredUser(
          email: user.email, uid: user.uid, userInfo: user.getIdToken(true));
    } else {
      return null;
    }
  }

  // get current logged in user.
  Stream<RegisteredUser> get user {
    return FirebaseAuth.instance
        .authStateChanges()
        .map((User user) => _userFromFirebase(user));
  }

  void signoutmethod() async {
    storage.delete(key: getCurrentUser());
    await auth.signOut();
  }

  Future signinmethod(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final token = await userCredential.user.getIdToken(true);
      // userCredential.user.g
      await storage.write(key: email, value: token);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not found';
      } else if (e.code == 'wrong-password') {
        return "Incorrect password";
      }
    }
  }

  Future resetPasswordmethod(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      // return "Link sent to $email";
    } catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not found';
      } else {
        return e.code;
      }
    }
  }

  Future createNewUser(String email, String role, String phone) async {
    role = role.toLowerCase();
    var url = Uri.parse('$host/$role/createuser');
    var body = {'email': email, 'password': phone};
    var response =
        await http.post(url, body: body, headers: await getRequestHeader());
    return jsonDecode(response.body);
  }

  Future addUser(String collection, data) async {
    try {
      var role = collection.toLowerCase();
      var url = Uri.parse('$host/$role/add');
      var userData = jsonEncode(data);
      await http.post(url,
          body: {'data': userData, 'collection': collection},
          headers: await getRequestHeader());
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future getRequestHeader() async {
    var header = {
      'Authorization': 'Bearer ' + await getTokenFromStorage(getCurrentUser())
    };
    return header;
  }
}
