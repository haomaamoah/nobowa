import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();
  AnimationController? rotationController;


  TextEditingController password = TextEditingController();
  bool loading = false;

  TextStyle headingStyle = TextStyle(decoration: TextDecoration.underline, fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600);
  EdgeInsets infoPadding = EdgeInsets.only(top: 2.0,bottom: 2.0,left:2.0,right: 2.0);
  OutlineInputBorder infoOutlineInputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(20),);


  void validate()async {
    if (_formKey.currentState!.validate()){
      try {
        DocumentSnapshot adminInfo = await AdminDB.getAdminInfo().timeout(const Duration(seconds: 10));
        if(adminInfo.exists){
          if(adminInfo["pwd"]!=password.text){
            print('1');
            NonUserDialog(context);
          }else {
            print('2');
            FileUtils.saveToFile(password.text);
            Navigator.pushReplacement(context, BouncyPageRoute(widget: HomePage()));
          }
        }else{
          print('3');
          NonUserDialog(context);
        }
      } on TimeoutException {
        print('Timeout');NoInternetDialog(context);

      } on Error catch (e) {
        print('Error: $e');
      }

    } else{
      print('not valid');
    }

    setState(()=>loading=!loading);
  }

  String? validateName(name){
    if (name.isEmpty) {
      return 'Name is required';
    } else{
      return null;
    }
  }





  // passWord Field
  Widget passWord(){
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: password,obscureText: true,
        decoration: InputDecoration(hintStyle: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w700),
          hintText: "ENTER PASSWORD",icon: FaIcon(FontAwesomeIcons.lock,color: Colors.red,),
        ),
        validator: validateName,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(vsync: this,duration: Duration(seconds: 10));
    rotationController!.repeat();
  }

  @override
  void dispose() {
    rotationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> SystemNavigator.pop() as Future<bool>,
      child: Material(child: Stack(children:[
        Center(
            child:Container(
              color:Colors.white,
              width: double.infinity,
              child: ListView(
                children: <Widget>[
                  AnimatedBuilder(
                      animation: rotationController!,
                      builder: (BuildContext context,widget){
                        return Transform.rotate(angle: rotationController!.value*6.3,child: widget,);
                      },
                      child:FadeAnimation(5,Curves.easeInBack,CircleAvatar(maxRadius: 100,backgroundColor: Colors.transparent,
                        child: Image.asset(DataUtils.mainLogo,
                          height: 150,width:150,
                          fit: BoxFit.cover,),
                      ))),
                  Padding(
                    padding: EdgeInsets.fromLTRB(60, 40, 60, 40),
                    child: FadeAnimation(3,Curves.fastOutSlowIn,Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 5,5, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [BoxShadow(
                            color: Colors.red,blurRadius: 5,offset: Offset(0,2)
                        ),],
                      ),
                      child: passWord(),
                    )),
                  ),
                  FadeAnimation(3,Curves.bounceInOut,Center(
                    child: GestureDetector(
                      onTap: ()async{
                        if (!RegExp(r"^\d{1,5}$").hasMatch(password.text)){NonUserDialog(context);}
                        else{
                          setState(()=>loading=!loading);
                          validate();
                        }
                      },
                      child: Container(
                        width: 150,height: 50,
                        padding: EdgeInsets.fromLTRB(40, 10, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text('LOGIN',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 25),),
                      ),
                    ),
                  )),
                  SizedBox(height: 20.0,),
                  Text('Powered by NOBOWA.com\n©2021',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54,
                        fontFamily: "Times New Roman",
                        fontWeight: FontWeight.w900,
                        fontSize: 14.0),),
                ],
              ),
            )),(loading)?Center(child: gradientCirclePBar()):SizedBox()])),
    );
  }
}
