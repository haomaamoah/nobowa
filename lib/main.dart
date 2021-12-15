// @dart=2.9
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'view/page/splash.dart';
import 'model/models.dart';
import 'view/page/home.dart';
import 'view/page/login.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


import 'model/file_utils.dart';


void main() async {
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        supportedLocales: Utils.supportedLocales,
        localizationsDelegates: Utils.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        title: 'NOBOWA.com',
        theme: Utils.themeData,
        home: const SplashScreen()
      //PaymentForm(),
      //PaymentPage()
      //NewsForm()
    );
  }
}

