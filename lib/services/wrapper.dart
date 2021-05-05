// file to check is user is logged in or not
import 'package:careconnect/models/registereduser.dart';
import 'package:careconnect/screens/admin_screen.dart';
import 'package:careconnect/screens/authentication/signin.dart';
import 'package:careconnect/screens/doctor_home.dart';
import 'package:careconnect/screens/patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<RegisteredUser>(context);
    if (user == null) {
      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: Signin(),
      );
    } else {
      // Navigator.pop(context);
      if (user.roleGet == 'doctor') {
        return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            child: DoctorHome(email: user.emailGet));
      } else if (user.roleGet == 'patient') {
        return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            child: PatientHome(
              email: user.emailGet,
            ));
      } else {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child: AdminHome(email: user.emailGet),
        );
      }
    }
  }
}
