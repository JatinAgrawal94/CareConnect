// Role based Authorization happens here

import 'package:flutter/material.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/screens/doctor_home.dart';
import 'package:careconnect/screens/patient_screen.dart';
import 'package:careconnect/screens/admin_screen.dart';
import 'package:careconnect/components/loading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RoleAuthorization extends StatefulWidget {
  final String email;
  final Future userInfo;
  RoleAuthorization({Key key, this.email, this.userInfo}) : super(key: key);

  @override
  _RoleAuthorizationState createState() =>
      _RoleAuthorizationState(email, this.userInfo);
}

class _RoleAuthorizationState extends State<RoleAuthorization> {
  final String email;
  final Future userInfo;
  String token;
  _RoleAuthorizationState(this.email, this.userInfo);
  AuthService auth = AuthService();
  var data;
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    auth.getRole(email).then((value) {
      if (mounted) {
        setState(() {
          data = value['role'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (data == 'doctor'
        ? DoctorHome(email: email)
        : data == 'patient'
            ? PatientHome(email: email)
            : data == 'admin'
                ? AdminHome(email: email)
                : LoadingHeart());
  }
}
