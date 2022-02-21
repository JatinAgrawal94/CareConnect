import 'package:careconnect/models/registereduser.dart';
import 'package:careconnect/services/wrapper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:careconnect/services/auth.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications',
    importance: Importance.high);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // NOTE: The filename will default to .env and doesn't need to be defined in this case
  await DotEnv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(SplashPage());
  //...runapp
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });
  }

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

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//     return FutureBuilder(
//         future: _initialization,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return null;
//           }

//           if (snapshot.connectionState == ConnectionState.done) {
//             return StreamProvider<RegisteredUser>.value(
//               value: AuthService().user,
//               initialData: null,
//               child: MaterialApp(
//                 home: Wrapper(),
//                 debugShowCheckedModeBanner: false,
//               ),
//             );
//           }
//           return MaterialApp(home: SplashPage());
//         });
//   }
// }

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
        seconds: 2,
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
