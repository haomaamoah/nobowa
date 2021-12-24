import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../view/page/website.dart';
import '../model/cloud_utils.dart';
import '../model/file_utils.dart';
import '../model/models.dart';
import '../view/widget/bouncy_page_route.dart';
import '../view/widget/dialogs.dart';

Future loginValidation({required GlobalKey<FormState> formKey,required BuildContext context,
  required String phone,required String password})async {
  if (formKey.currentState!.validate()){
    try {
      QuerySnapshot userInfo = await UsersDB.validUser(phone).timeout(const Duration(seconds: 10));
      if(userInfo.docs[0].exists){
        Users _ = Users.fromMap(userInfo.docs[0].data());
        if(_.password!=password){
          nonUserDialog(context);
        }else {
          FileUtils.saveToFile(phone);
          Navigator.pushReplacement(context, BouncyPageRoute(widget: Website()));
        }
      }else{
        nonUserDialog(context);
      }
    } on TimeoutException {
      noInternetDialog(context);
    } on Error catch (e) {
      nonUserDialog(context);
      print('Error: $e');
    }
  }
}



String? validateName(name){
  if (name.isEmpty) {
    return 'Name is required';
  } else{
    return null;
  }
}
String? validateSignupPassword(String? name){
  if (name!.isEmpty || name.length<8 || !RegExp(r"\d+").hasMatch(name) || !RegExp(r"[a-z]").hasMatch(name) ) {
    return 'Minimum: 8 characters;\nMust contain at least:\n1 lowercase letter and 1 number';
  }
  else{return null;}
}

String? validateLoginPassword(String? name){
  if (name!.isEmpty) {
    return 'Password is required';
  }
  else{
    if (name.length<8 || !RegExp(r"\d+").hasMatch(name) || !RegExp(r"[a-z]").hasMatch(name) ) {
      return "Password and Phone records don't match";
    }
    else{return null;}
  }
}

String? validateEmail(name){
  if (name.isEmpty) {
    return 'Email is required';
  } else{
    return null;
  }
}

String? validatePhone(name){
  if (name.length <= 4) {
    return 'Phone number is required';
  }
  else if (name.length < 9) {
    return 'Phone must at least\n9 characters long!';
  }else{
    return null;
  }
}