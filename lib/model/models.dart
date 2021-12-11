import 'dart:ui';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nobowa/view/page/login.dart';

class Users {
  late String name,password,email,phone,location,profession;
  late Timestamp timestamp;

  Users([name,password,email,phone,location,profession,timestamp]);

  Map<String,dynamic> toMap(){
    var map = <String, dynamic>{
      'name': name,'email': email,'phone': phone,'password': password,
      'location': location,'profession': profession,'timestamp': timestamp,
    }; return map;
  }

  Users.fromMap(var map){
    name = map['name'];email = map['email'];phone = map['phone'];password = map['password'];
    location = map['location'];profession = map['profession'];timestamp = map['timestamp'];
  }
}


class Utils {
  static const String
  iconLogo = 'assets/images/companyLogo.png', bannerLogo = 'assets/images/companyBanner.png';

  static const List<String> professions =
  ["STUDENT","TEACHING STAFF","FARMER","SELF EMPLOYED","PRIVATE WORKER","PUBLIC WORKER","JUST INTERESTED"];

  static const List<Locale> supportedLocales =
  [
    Locale("af"),Locale("am"),Locale("ar"),Locale("az"),Locale("be"),Locale("bg"),Locale("bn"),Locale("bs"),Locale("ca"),Locale("cs"),
    Locale("da"),Locale("de"),Locale("el"),Locale("en"),Locale("es"),Locale("et"),Locale("fa"),Locale("fi"),Locale("fr"),Locale("gl"),
    Locale("ha"),Locale("he"),Locale("hi"),Locale("hr"),Locale("hu"),Locale("hy"),Locale("id"),Locale("is"),Locale("it"),Locale("ja"),
    Locale("ka"),Locale("kk"),Locale("km"),Locale("ko"),Locale("ku"),Locale("ky"),Locale("lt"),Locale("lv"),Locale("mk"),Locale("ml"),
    Locale("mn"),Locale("ms"),Locale("nb"),Locale("nl"),Locale("nn"),Locale("no"),Locale("pl"),Locale("ps"),Locale("pt"),Locale("ro"),
    Locale("ru"),Locale("sd"),Locale("sk"),Locale("sl"),Locale("so"),Locale("sq"),Locale("sr"),Locale("sv"),Locale("ta"),Locale("tg"),
    Locale("th"),Locale("tk"),Locale("tr"),Locale("tt"),Locale("uk"),Locale("ug"),Locale("ur"),Locale("uz"),Locale("vi"), Locale("zh")
  ];
  static const List<LocalizationsDelegate> localizationsDelegates = 
  [CountryLocalizations.delegate,GlobalMaterialLocalizations.delegate,GlobalWidgetsLocalizations.delegate,];

  static const yellowColor = Color(0xFFffec00);
  static const brownColor = Color(0xFF4f2d01);

  static double screenHeight(_)=>MediaQuery.of(_).size.height;
  static double screenWidth(_)=>MediaQuery.of(_).size.width;

  static ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: brownColor,

    // Define the default font family.
    fontFamily: 'Georgia',

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );
}
