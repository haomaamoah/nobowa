import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nobowa/model/file_utils.dart';
import 'package:nobowa/view/page/login.dart';
import 'package:nobowa/view/page/website.dart';
import 'package:nobowa/view/widget/bouncy_page_route.dart';
import '../../model/models.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  late AnimationController rotationController;

  Stream<ConnectivityResult> subscription = Connectivity().onConnectivityChanged;

  Future<void> launchWebsite () async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {Navigator.of(context).pushReplacement(FadePageRoute(widget: NoInternet()));}
    else{
      String? data = await FileUtils.readFromFile();
      Navigator.of(context).pushReplacement(FadePageRoute(widget: (data!=null) ? Website() : LoginForm()));
    }
  }



  @override
  void initState(){
    super.initState();
    rotationController = AnimationController(vsync: this,duration: Duration(seconds: 4));
    rotationController.repeat();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    launchWebsite();
    return Scaffold(
            body: Container(
              width: double.infinity,height: double.infinity,
              color: Colors.white,
              child: Center(
                child:
                AnimatedBuilder(
                    animation: rotationController,
                    builder: (BuildContext context,widget){
                      return Transform.rotate(angle: rotationController.value*6.3,child: widget,);
                    },
                    child:Image.asset(Utils.iconLogo,fit: BoxFit.cover,)),
              ),
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
