import 'dart:async';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:careconnect/models/registereduser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:mailgun/mailgun.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String role = 'doctor';
  static String userid;

  Future getRole(String email) async {
    List data = [];
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        // print(element['role']);
        data.add({'role': element['role']});
      });
    });
    return data;
  }

  // get RegisteredUser(model) format for logged in user.
  RegisteredUser _userFromFirebase(User user) {
    if (user != null) {
      return RegisteredUser(
        email: user.email,
        uid: user.uid,
      );
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
    await auth.signOut();
  }

  Future signinmethod(String email, String password) async {
    try {
      await _authorize(email);
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not found';
      } else if (e.code == 'wrong-password') {
        return "Incorrect password";
      }
    }
  }

  Future _authorize(String email) async {
    List data = [];
    // print("I was in authorize");
    await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      role = snapshot.docs[0]['role'];
      userid = snapshot.docs[0]['userid'];
      data.add({
        'role': snapshot.docs[0]['role'],
        'userid': snapshot.docs[0]['userid']
      });
    });
    return data;
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

  Future registerUserWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "user-created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {
        return 'email-already-in-use';
      }
    } catch (e) {
      return e;
    }
  }

  Future randomPasswordGenerator() async {
    final password = RandomPasswordGenerator();
    String newPassword = password.randomPassword(true, false, true, false, 7);
    return newPassword;
  }

  Future registerUser(String email) async {
    String password = await randomPasswordGenerator();
    String result = await registerUserWithEmailAndPassword(email, password);
    if (result == "user-created") {
      return {'password': password, 'msg': result};
    } else if (result == 'email-already-in-use') {
      return {'msg': result};
    } else {
      return {'msg': result};
    }
  }

  Future sendMails(String email, String password) async {
    // var apiKey = env['API_KEY'];
    // var domain = env['DOMAIN_NAME'];

    // var mailgun = MailgunMailer(domain: domain, apiKey: apiKey);
    // await mailgun.send(
    //     from: "CareConnect<jatinagrawal0801@gmail.com>",
    //     to: [email],
    //     subject: "Password for CareConnect Account",
    //     text:
    //         "Your Password is $password \n Note:This is a machine generated Password.Kindly reset password to ensure security");
  }
}
