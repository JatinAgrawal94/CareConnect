import 'package:firebase_auth/firebase_auth.dart';
import 'package:careconnect/models/registereduser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String role = 'doctor';

  // get RegisteredUser(model) format for logged in user.
  RegisteredUser _userFromFirebase(User user) {
    if (user != null) {
      return RegisteredUser(
          email: user.email, uid: user.uid, role: AuthService.role);
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

  _authorize(String email) async {
    _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      role = snapshot.docs[0]['role'];
    });
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
}
