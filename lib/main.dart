import 'package:careconnect/models/registereduser.dart';
import 'package:careconnect/services/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:careconnect/services/auth.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
// import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  // NOTE: The filename will default to .env and doesn't need to be defined in this case
  await DotEnv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SplashPage());
  //...runapp
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return null;
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<RegisteredUser>.value(
              value: AuthService().user,
              initialData: null,
              child: MaterialApp(
                home: Wrapper(),
                debugShowCheckedModeBanner: false,
              ),
            );
          }
          return MaterialApp(home: SplashPage());
        });
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: Colors.deepPurple,
              cursorColor: Colors.deepPurple,
              selectionColor: Colors.deepPurple)),
      home: SplashScreen(
        seconds: 4,
        navigateAfterSeconds: MyApp(),
        title: new Text(
          'CareConnect',
          textScaleFactor: 2,
        ),
        image: Image(
          image: AssetImage('assets/heart.png'),
        ),
        photoSize: 100.0,
      ),
    );
  }
}
