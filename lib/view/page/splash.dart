import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nobowa/view/page/login.dart';
import '../../model/file_utils.dart';
import 'website.dart';
import '../widget/bouncy_page_route.dart';
import '../../model/models.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  late AnimationController rotationController;

  var timer;

  String? data;

  bool oldUser = false;

  bool loading = true;

  Stream<ConnectivityResult> subscription = Connectivity().onConnectivityChanged;

  Future<void> checkIfOldUser()async{
    data = await FileUtils.readFromFile();
    setState((){
      oldUser = (data!=null) ? true : false;
      loading = false;
    });
    if(oldUser) {
      timer = Timer.periodic(Duration(seconds:1), (timer){
        if(timer.tick == 5){launchWebsite();timer.cancel();}
      });
    }
  }

  Future<void> launchWebsite () async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {Navigator.of(context).pushReplacement(FadePageRoute(widget: const NoInternet()));}
    else{
      Navigator.of(context).pushReplacement(FadePageRoute(widget: Website()));
    }
  }



  @override
  void initState(){
    super.initState();
    rotationController = AnimationController(vsync: this,duration: Duration(seconds: 4));
    rotationController.repeat();
    checkIfOldUser();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
            body: Stack(
              children: [
                if(!loading)Image.asset((oldUser)?Utils.introOldUserBg:Utils.introNewUserBg,fit: BoxFit.cover,width: Utils.screenWidth(context),height: Utils.screenHeight(context),),
                if(!loading)Column(
                  mainAxisAlignment:(oldUser)?MainAxisAlignment.center: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: SizedBox(
                        width: (oldUser)?150:100,height: (oldUser)?150:100,
                        child: AnimatedBuilder(
                            animation: rotationController,
                            builder: (BuildContext context,widget){
                              return Transform.rotate(angle: rotationController.value*6.3,child: widget,);
                            },
                            child:Image.asset(Utils.iconLogo,fit: BoxFit.cover,)),
                      ),
                    ),
                    if(!oldUser)Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text("Welcome to NOBOWA.com",
                      style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: "Times New Roman",fontWeight: FontWeight.w600),),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, (oldUser)?50:30, 0, 30),
                      child: Text("Africa’s Agricultural Knowledge Base",textAlign: TextAlign.center,
                        style: TextStyle(color: Utils.brownColor,fontSize: 26,fontFamily: "Poppins",fontWeight: FontWeight.w800),
                      ),
                    ),
                    if(!oldUser)Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                      child: Text("Get all the information and guide in areas across the entire agricultural value chain",textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: "Times New Roman",fontWeight: FontWeight.w600)),
                    ),
                    if(!oldUser)Container(
                      height: 40,width: 200,
                      child: RaisedButton(
                        color: Utils.brownColor,
                        onPressed: ()=>Navigator.pushReplacement(context, BouncyPageRoute(widget: LoginForm())),
                        child: Center(child: Text('Get Started',style: TextStyle(color: Colors.white,fontFamily: "Roboto",fontWeight: FontWeight.bold,fontSize: 20),)),
                      ),
                    ),
                  ],
                ),
                if(oldUser)Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "NOBOWA.COM",style: TextStyle(color: Utils.brownColor,fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.w600)
                  ),
                )
              ],
            ),
          );
  }
}

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.satelliteDish,size: 100,color: Colors.red,),
            Divider(),
            Text(
              "\nNO INTERNET CONNECTION!\n",
              style: TextStyle(fontWeight: FontWeight.w800,color: Utils.brownColor,fontSize: 18),
            ),
            Divider(),
            Text(
              "Check your network or settings.",
              style: TextStyle(fontSize: 12,fontFamily: "Times New Roman"),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushReplacement(FadePageRoute(widget: SplashScreen()));
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Utils.yellowColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(child: Text('TRY AGAIN',style: TextStyle(color: Utils.brownColor,fontFamily: "Times New Roman",fontWeight: FontWeight.w900,fontSize: 20),)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
