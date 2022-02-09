// Role based Authorization happens here

import 'package:flutter/material.dart';
import 'package:careconnect/services/auth.dart';
import 'package:careconnect/screens/doctor_home.dart';
import 'package:careconnect/screens/patient_screen.dart';
import 'package:careconnect/screens/admin_screen.dart';
import 'package:careconnect/components/loading.dart';

class RoleAuthorization extends StatefulWidget {
  final String email;
  RoleAuthorization({Key key, this.email}) : super(key: key);

  @override
  _RoleAuthorizationState createState() => _RoleAuthorizationState(email);
}

class _RoleAuthorizationState extends State<RoleAuthorization> {
  final String email;
  _RoleAuthorizationState(this.email);
  AuthService auth = AuthService();
  var data;
  @override
  void initState() {
    super.initState();

    auth.getRole(email).then((value) {
      if (mounted) {
        setState(() {
          data = value[0]['role'];
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
