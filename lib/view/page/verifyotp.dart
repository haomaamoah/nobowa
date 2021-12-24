import 'dart:async';

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import '../../model/cloud_utils.dart';
import '../../model/file_utils.dart';
import '../../model/models.dart';
import 'website.dart';
import '../widget/accessories.dart';
import '../widget/dialogs.dart';

import 'changepass.dart';

class VerifyOTPForm extends StatefulWidget {
  Users user;bool forgotPassword;
  VerifyOTPForm(this.user,[this.forgotPassword=false]){this.user=user;this.forgotPassword=forgotPassword;}

  @override
  _VerifyOTPFormState createState() => _VerifyOTPFormState();
}

class _VerifyOTPFormState extends State<VerifyOTPForm> {
  String? _enteredOTP;
  

  @override
  Widget build(BuildContext context) {
    return FirebasePhoneAuthProvider(
      child: SafeArea(
        child: FirebasePhoneAuthHandler(
          phoneNumber: widget.user.phone,
          timeOutDuration: const Duration(seconds: 60),
          onLoginSuccess: (userCredential, autoVerified) async {
            if (widget.forgotPassword){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>PasswordForm(widget.user)));
            }else{
              Future<void> userInfo = UsersDB.addUser(widget.user).timeout(const Duration(seconds: 10));
              userInfo.then((value){
                FileUtils.saveToFile(widget.user.phone);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Website()));
              }).
              catchError((error){
                print(error);
                Navigator.of(context).pop();
                (error.runtimeType == TimeoutException)? noInternetDialog(context) :
                statusDialog(context, false,"SIGNUP FAILED!\nPlease try again.");
              });
            }
          },
          onLoginFailed: (authException) {
            Navigator.of(context).pop();
            print("An error occurred: ${authException.message}");
            statusDialog(context, false,"VERIFICATION FAILED!\nPlease try again.");

            // handle error further if needed
          },
          builder: (context, controller) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("N O B ",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w900),),
                    Image.asset(Utils.iconLogo,fit: BoxFit.contain,width: 30,height: 35,),
                    const Text(" W A",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w900),)
                  ],
                ),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            Color(0xFF4f2d01),
                            Color(0xFFffec00),
                            Color(0xFF4f2d01),
                          ])
                  ),
                ),
                actions: controller.codeSent
                    ? [
                  TextButton(
                    child: Text(
                      controller.timerIsActive
                          ? "${controller.timerCount.inSeconds}s"
                          : "RESEND",
                      style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18),
                    ),
                    onPressed: controller.timerIsActive
                        ? null
                        : () async {
                      await controller.sendOTP();
                    },
                  ),
                  SizedBox(width: 5),
                ]
                    : null,
              ),
              body: controller.codeSent
                  ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(
                      "We've sent an SMS with a verification code to ${widget.user.phone}",textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF4f2d01),fontSize: 25,fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    AnimatedContainer(
                      duration: Duration(seconds: 3),
                      height: controller.timerIsActive ? null : 0,
                      child: Column(
                        children: [
                          GradientCirclePBar(),
                          SizedBox(height: 50),
                          Text(
                            "Listening for OTP",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF4f2d01),fontWeight: FontWeight.w400),
                          ),
                          Divider(),
                          Text("OR", textAlign: TextAlign.center),
                          Divider(),
                        ],
                      ),
                    ),
                    SizedBox(height:20),
                    Text(
                      "Enter Code Manually",textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF4f2d01),fontSize: 20,fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        maxLength: 6,style: TextStyle(color: Color(0xFF4f2d01),fontSize: 20,fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.number,
                        onChanged: (String v) async {
                          _enteredOTP = v;
                          if (this._enteredOTP?.length == 6) {
                            final res =
                            await controller.verifyOTP(otp: _enteredOTP!);
                            // Incorrect OTP
                            if (!res)
                              print(
                                "Please enter the correct OTP sent to ${widget.user.phone}",
                              );
                          }
                        },
                      ),
                    ),
                ],
              ),
                  )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GradientCirclePBar(),
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      "Sending OTP",
                      style: TextStyle(color: Color(0xFF4f2d01),fontSize: 20,fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              floatingActionButton: controller.codeSent
                  ? FloatingActionButton(
                backgroundColor: Utils.yellowColor,
                child: Icon(Icons.check,color: Utils.brownColor,size:40),
                onPressed: () async {
                  if (_enteredOTP == null || _enteredOTP?.length != 6) {
                    print("Please enter a valid 6 digit OTP");
                  } else {
                    final res =
                    await controller.verifyOTP(otp: _enteredOTP!);
                    // Incorrect OTP
                    if (!res)
                      print(
                        "Please enter the correct OTP sent to $widget.phone",
                      );
                  }
                },
              )
                  : null,
            );
          },
        ),
      ),
    );
  }
}
