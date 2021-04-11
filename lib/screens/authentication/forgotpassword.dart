import 'package:flutter/material.dart';
import 'package:careconnect/services/auth.dart';

class PasswordReset extends StatefulWidget {
  PasswordReset({Key key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final GlobalKey<FormState> resetpasswordkey = GlobalKey<FormState>();
  String email = "";
  final fieldText = TextEditingController();

  final AuthService _auth = AuthService();

  void clearText() {
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black)),
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            child: FractionallySizedBox(
                heightFactor: 1.0,
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    color: Colors.white10,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Enter Email",
                            style: TextStyle(fontSize: 36),
                          ),
                          Form(
                              key: resetpasswordkey,
                              child: TextFormField(
                                controller: fieldText,
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0))),
                                style: TextStyle(fontSize: 20.0),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Field can/'t be empty";
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                              )),
                          Container(
                            width: double.infinity,
                            height: 60,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (resetpasswordkey.currentState.validate()) {}
                                dynamic result =
                                    await _auth.resetPasswordmethod(email);

                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(SnackBar(
                                //   content: Text(result),
                                // ));

                                if (result == null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Link Sent to $email"),
                                  ));
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(result),
                                  ));
                                }
                                clearText();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.indigo)),
                              child: Text('Reset Password',
                                  style: TextStyle(fontSize: 17)),
                            ),
                          )
                        ],
                      ),
                    )))));
  }
}
