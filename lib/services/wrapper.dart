// file to check is user is logged in or not
import 'package:careconnect/models/registereduser.dart';
import 'package:careconnect/screens/authentication/signin.dart';
import 'package:careconnect/services/role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  // @override
  // void initState() {
  //   super.initState();
  //   // getToken();
  // }

  getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

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
      return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child:
              RoleAuthorization(email: user.emailGet, userInfo: user.userInfo));
    }
  }
}
