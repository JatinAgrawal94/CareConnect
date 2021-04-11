// signin page
import 'package:careconnect/screens/authentication/forgotpassword.dart';
import 'package:careconnect/services/auth.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  Signin({Key key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<FormState> loginformkey = GlobalKey<FormState>();
  AuthService _auth = AuthService();
  String email = "";
  String password = "";
  bool loading = false;
  String error = "";
  bool _hidetext = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // background Image
            Container(
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/doctor.png'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.blue[200].withOpacity(0.8), BlendMode.srcOver),
                ),
              ),
            ),
            // Heart logo container
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      alignment: Alignment(-1, -1),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                              image: AssetImage('assets/heart.png'),
                              fit: BoxFit.fitHeight)),
                    ),
                    // Form Container
                    Container(
                      padding: EdgeInsets.all(14),
                      child: new Form(
                          key: loginformkey,
                          child: new Column(
                            children: <Widget>[
                              //Email field
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'field can\'t be empty ';
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0))),
                              ),
                              SizedBox(
                                height: 25.0,
                              ),
                              //Password field
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'field can\'t be empty ';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0)),
                                    suffixIcon: IconButton(
                                        icon: Icon(_hidetext
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            _hidetext = !_hidetext;
                                          });
                                        })),
                                obscureText: _hidetext,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              // LoGin button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green[400],
                                      onPrimary: Colors.white,
                                      minimumSize: Size.fromHeight(45)),
                                  onPressed: () async {
                                    if (loginformkey.currentState.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await _auth.signinmethod(
                                          email, password);

                                      if (result == null) {
                                        setState(() {
                                          error = 'could not sign in';
                                          loading = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("Signin Failed"),
                                          ));
                                        });
                                      } else {
                                        if (result.runtimeType == String) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(result),
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("SignIn Successfull"),
                                          ));
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PasswordReset()));
                                  },
                                  child: Text('Forgot Password ?')),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
