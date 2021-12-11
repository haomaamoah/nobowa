import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nobowa/controller/buttonActions.dart';
import 'package:nobowa/model/models.dart';
import 'package:nobowa/view/page/login.dart';
import 'package:nobowa/view/widget/dialogs.dart';


class GradientCirclePBar extends StatefulWidget {
  @override
  _GradientCirclePBarState createState() => _GradientCirclePBarState();
}

class _GradientCirclePBarState extends State<GradientCirclePBar> with TickerProviderStateMixin{
  AnimationController? rotationController;
  @override
  void initState(){
    super.initState();
    rotationController = AnimationController(vsync: this,duration: Duration(seconds: 1));
    rotationController?.repeat();
  }
  @override
  void dispose() {
    rotationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black54,
                  width: 2
              )
          ),
          width: 100,height: 100,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              children: const [
                CircularProgressIndicator(
                  strokeWidth: 10,
                  color: Colors.redAccent,
                ),
                SizedBox(height: 20,),
                Text('LOADING...',
                  style: TextStyle(
                      fontSize: 15,fontFamily: "Gothic Bold",
                      fontWeight: FontWeight.w800,fontStyle: FontStyle.italic
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}

AppBar mainAppBar(){
  return AppBar(
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("N O B ",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.w900),),
        Image.asset(Utils.iconLogo,fit: BoxFit.contain,width: 35,height: 35,),
        const Text(" W A",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.w900),)
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
  );
}


SpeedDial floatingActionButton(context){
  TextStyle _labelStyle = TextStyle(fontSize: 20.0,color: Utils.brownColor,fontWeight: FontWeight.bold,fontFamily: "Poppins");
  return SpeedDial(
    childMargin: EdgeInsets.fromLTRB(0, 10, 0, 10), animatedIcon: AnimatedIcons.menu_home, animatedIconTheme: IconThemeData(size: 22.0), buttonSize: Size(50,50),elevation: 8.0, shape: CircleBorder(),
    tooltip: 'MENU', backgroundColor: Utils.brownColor, foregroundColor: Colors.white, curve: Curves.bounceInOut, overlayColor: Colors.black, overlayOpacity: 0.5,
    children: [
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.powerOff,size: 30,color: Colors.red,)),
        backgroundColor: Utils.yellowColor,
        label: 'EXIT',
        labelStyle: _labelStyle,
        onTap: exitApp,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(Icons.logout_rounded,size: 30,color: Colors.orange,)),
        backgroundColor: Utils.yellowColor,
        label: 'LOGOUT',
        labelStyle: _labelStyle,
        onTap: ()=>logoutDialog(context, const LoginForm()),
      ),
    ],
  );
}
