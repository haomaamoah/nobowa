// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'view/page/splash.dart';
import 'model/models.dart';
import 'view/page/home.dart';
import 'view/page/login.dart';

import 'model/file_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        title: 'NOBOWA',
        theme: Utils.themeData,
        home: FutureBuilder(
            initialData: null,
            future: FileUtils.readFromFile(),
            builder: (context,data){
              bool homepage = false;
              if(data.connectionState == ConnectionState.done && data.hasData)homepage=true;
              return (homepage) ? SplashScreen() : LoginForm();
            })
      //PaymentForm(),
      //PaymentPage()
      //NewsForm()
    );
  }
}

