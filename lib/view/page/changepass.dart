import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/validation.dart';
import '../../model/cloud_utils.dart';
import 'login.dart';
import 'website.dart';
import '../widget/accessories.dart';
import '../widget/dialogs.dart';
import '../../model/models.dart';

class PasswordForm extends StatefulWidget {
  final Users user;
  const PasswordForm(this.user, {Key? key}) : super(key: key);

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
      fontWeight: FontWeight.w800,color: Utils.brownColor
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Website()));
      })
          .catchError((error){
        print("Failed to add admin: $error");
        (error.runtimeType == TimeoutException)? noInternetDialog(context) :
        statusDialog(context, false,"UPDATE FAILED!");
        setState(()=>loading=!loading);
      });
    }

  }

  String? validateConfirmPassword(password){
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
          autovalidateMode: AutovalidateMode.always,

          decoration: InputDecoration(
              errorStyle: const TextStyle(fontSize: 13,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
              labelStyle: const TextStyle(color: Utils.brownColor,fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
              border: infoOutlineInputBorder,labelText: "NEW PASSWORD",icon: FaIcon(Icons.lock,color: Colors.red,size: 28,)
          ),
          validator: validateSignupPassword,
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true, keyboardType: TextInputType.text,
          decoration: InputDecoration(
              errorStyle: const TextStyle(fontSize: 13,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
              labelStyle: const TextStyle(color: Utils.brownColor,fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
              border: infoOutlineInputBorder,labelText: "CONFIRM PASSWORD",icon: FaIcon(Icons.lock,color: Colors.red,size: 28,)
          ),
          validator: validateConfirmPassword,
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
                      child: Container(height: 35, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Utils.yellowColor
                      ),
                          child:MaterialButton(elevation: 5.0,child: const Text("SUBMIT",
                            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Utils.brownColor),
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
