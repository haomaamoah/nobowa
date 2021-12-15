import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nobowa/controller/validation.dart';
import 'package:nobowa/view/page/signup.dart';
import 'package:nobowa/view/page/verifyotp.dart';
import '../../model/cloud_utils.dart';
import '../../model/file_utils.dart';
import '../../model/models.dart';
import '../widget/accessories.dart';
import '../widget/bouncy_page_route.dart';
import '../widget/dialogs.dart';

import 'home.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();
  late String dialCode;
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;

  TextStyle headingStyle = const TextStyle(decoration: TextDecoration.underline, fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600);
  EdgeInsets infoPadding = const EdgeInsets.only(top: 2.0,bottom: 2.0,left:2.0,right: 2.0);
  OutlineInputBorder infoOutlineInputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(20),);


  // Phone Field
  Widget phoneField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text("Select Your Country",style: TextStyle(fontSize: 12,color: Colors.redAccent),),
              CountryCodePicker(
                onChanged: (code) => dialCode = code.dialCode!,
                initialSelection: "GH",
                onInit: ( code) => dialCode = code!.dialCode!,
                padding: const EdgeInsets.all(0),
                textStyle: TextStyle(color: Color(0xFF4f2d01),fontWeight: FontWeight.w400,fontSize: 20),
                flagDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 200,
            child: TextFormField(
              controller: phone,keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                hintStyle: TextStyle(color: Color(0xFF4f2d01),fontWeight: FontWeight.w400),
                hintText: "ENTER MOBILE",
              ),
              validator: validatePhone,
            ),
          ),
        ],
      ),
    );
  }


  Widget passWord(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: TextFormField(
        controller: password,obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          hintStyle: TextStyle(color: Color(0xFF4f2d01),fontWeight: FontWeight.w400),
          hintText: "ENTER PASSWORD",icon: FaIcon(FontAwesomeIcons.lock,color: Colors.redAccent,),
        ),
        validator: validateLoginPassword,
      ),
    );
  }

  AnimationController? _breathingController; double _breathe = 0;
  @override
  void initState(){
    super.initState();
    _breathingController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _breathingController!.addStatusListener((status) {
      if (status == AnimationStatus.completed){_breathingController!.reverse();}
      else if (status == AnimationStatus.dismissed){_breathingController!.forward();}});
    _breathingController!.addListener(() {setState(() {_breathe = _breathingController!.value;});});_breathingController!.forward();
  }
  @override
  void dispose() {
    _breathingController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> SystemNavigator.pop() as Future<bool>,
      child: Material(child: Stack(children:[
        Center(
            child:Form(
              key: _formKey,
              child: Container(
                color:Colors.white,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                      child: SizedBox(height: 110,
                        child: Image.asset(Utils.bannerLogo,
                          fit: BoxFit.contain,width: 300 + 20 * _breathe,height: 100 + 20 * _breathe,),
                      ),
                    ),
                    phoneField(),
                    passWord(),
                    const SizedBox(height: 10.0,),
                    GestureDetector(
                      onTap: (){
                        try {
                          searchPhoneDialog(context).then((_phone)async{
                            if (_phone.runtimeType==String){
                              setState(()=>loading=!loading);
                              QuerySnapshot userInfo = await UsersDB.validUser(_phone).timeout(const Duration(seconds: 10));
                              if(userInfo.docs.length>=1){
                                Users user = Users.fromMap(userInfo.docs[0].data());
                                Navigator.push(context, BouncyPageRoute(widget: VerifyOTPForm(user,true)));
                              }else{
                                setState(()=>loading=!loading);
                                nonUserDialog(context);
                              }
                            }
                          });
                        } on TimeoutException {
                          setState(()=>loading=!loading);
                          noInternetDialog(context);
                        } on RangeError {
                          setState(()=>loading=!loading);
                          statusDialog(context,false,"NOT A REGISTERED USER!");
                        } on Error catch (e) {
                          setState(()=>loading=!loading);
                          statusDialog(context,false,"NOT A REGISTERED USER!");
                          print('Error: $e');
                        }
                      },
                      child: const Text('Forgot Password?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w900,
                            fontSize: 13.0),),
                    ),
                    SizedBox(height: 10.0,),
                    GestureDetector(
                      onTap: ()async{
                        setState(()=>loading=!loading);
                        String formattedPhone = (phone.text[0] == "0" && phone.text.length >= 10)? phone.text.substring(1,) : phone.text;
                        await loginValidation(formKey: _formKey, context: context, phone: dialCode+formattedPhone, password: password.text);
                        setState(()=>loading=!loading);

                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Utils.yellowColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(child: Text('LOGIN',style: TextStyle(color: Utils.brownColor,fontFamily: "Times New Roman",fontWeight: FontWeight.w900,fontSize: 27 + 3 * _breathe),)),
                          ),
                        ),
                      )
                    ),
                    const SizedBox(height: 10.0,),
                    Center(
                      child: GestureDetector(
                        onTap: ()=>Navigator.push(context, BouncyPageRoute(widget: SignupForm())),
                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Not a member?",
                                style: TextStyle(
                                    color: Colors.black54,fontFamily: "Times New Roman",
                                    fontWeight: FontWeight.w900,fontSize: 16.0
                                )
                              ),
                              TextSpan(
                                  text: " SIGN UP",
                                  style: TextStyle(
                                      color: Colors.blue,fontFamily: "Times New Roman",
                                      fontWeight: FontWeight.w900,fontSize: 18.0
                                  )
                              )
                            ]
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Text('NOBOWA.com ©2021',
            style: TextStyle(color: Colors.black54,
                fontFamily: "Times New Roman",
                fontWeight: FontWeight.w900,
                fontSize: 15.0),),
        ),
        (loading)?Center(child: GradientCirclePBar()):SizedBox()])),
    );
  }
}
