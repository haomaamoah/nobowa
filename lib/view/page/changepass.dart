import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:nobowa/model/cloud_utils.dart';
import 'package:nobowa/view/page/login.dart';
import 'package:nobowa/view/widget/accessories.dart';
import 'package:nobowa/view/widget/dialogs.dart';
import '../../model/models.dart';
import 'home.dart';

class PasswordForm extends StatefulWidget {
  Users user;
  PasswordForm(this.user);

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();



  TextStyle headingStyle = const TextStyle(
      fontSize: 20,fontFamily: "Poppins",
      fontWeight: FontWeight.w800
  );

  EdgeInsets infoPadding = const EdgeInsets.fromLTRB(35, 20, 35, 20);
  OutlineInputBorder infoOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  );

  void validate()async {
    if (_formKey.currentState!.validate()){
      print('validated');setState(()=>loading=!loading);
      widget.user.password = newPassword.text;
      UsersDB.updatePassword(widget.user).timeout(const Duration(seconds: 10))
          .then((value){
        print("Password Updated");
        statusDialog(context, true,"PASSWORD UPDATED!");
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const HomePage()));
      })
          .catchError((error){
        print("Failed to add admin: $error");
        (error.runtimeType == TimeoutException)? noInternetDialog(context) :
        statusDialog(context, false,"UPDATE FAILED!");
        setState(()=>loading=!loading);
      });
    }

  }


  String? validateNewPass(password){
    if (password.isEmpty) {
      return 'New password is required';
    }
    else if(newPassword.text!=confirmPassword.text) {
      return 'Passwords do not match. Try Again.';
    } else{
      return null;
    }
  }


  // Personal Phone
  Widget _newPassword(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          obscureText: true, keyboardType: TextInputType.text,
          controller: newPassword,
          decoration: InputDecoration(
              border: infoOutlineInputBorder,labelText: "NEW PASSWORD"
          ),
          validator: validateNewPass,
        ),
      ),
    );
  }

  // Personal Password
  Widget _confirmPassword(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          controller: confirmPassword,
          obscureText: true, keyboardType: TextInputType.text,
          decoration: InputDecoration(
              border: infoOutlineInputBorder,labelText: "CONFIRM NEW PASSWORD"
          ),
          validator: validateNewPass,
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const LoginForm())) as Future<bool>,
      child: Scaffold(
        appBar: mainAppBar(),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    Center(
                      child: Text(
                        "CHANGE PASSWORD",
                        style: headingStyle,
                      ),
                    ),
                    const Divider(thickness: 1,color: Colors.black,indent: 35,endIndent: 35,),
                    _newPassword(),
                    _confirmPassword(),
                    const Divider(),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                      child: Container(height: 35, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
                      ),
                          child:MaterialButton(elevation: 5.0,child: const Text("SUBMIT",
                            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                          ),
                              onPressed: validate
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ]
              ),
            ),(loading)?Center(child: GradientCirclePBar()):const SizedBox(),
          ],
        ),
      ),
    );
  }
}
