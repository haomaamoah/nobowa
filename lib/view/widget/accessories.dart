import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:simple_animations/simple_animations.dart';

enum AniProps { opacity, translateY }
class FadeAnimation extends StatelessWidget {

  final double delay; final Widget child; final Curve curve;
  FadeAnimation(this.delay,this.curve,this.child);
  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.opacity, Tween(begin: 0.0, end: 1.0), Duration(milliseconds: 500))
      ..add(AniProps.translateY, Tween(begin: 0.0, end: 1.0), Duration(milliseconds: 500),
          curve);


    return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AniProps.opacity),
        child: Transform.translate(
            offset: Offset(0, value.get(AniProps.translateY)), child: child),
      ),
    );
  }
}

class gradientCirclePBar extends StatefulWidget {
  @override
  _gradientCirclePBarState createState() => _gradientCirclePBarState();
}

class _gradientCirclePBarState extends State<gradientCirclePBar> with TickerProviderStateMixin{
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
              children: [
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

Widget HomeButton(context,function,icon,color,double breather) =>
    GestureDetector(
      onTap: ()=>function(),
      child: Container(
        width: 50,height: 50,
        decoration: BoxDecoration(
            color: color[200],
            borderRadius: BorderRadius.circular(40.0)),
      child:Center(child: (icon.runtimeType == String) ?
      Text(
          icon,style: TextStyle(fontSize: 35 - 10 * breather,color: Colors.black)
      ) :
      FaIcon(icon,color: Colors.black,size: 35 - 10 * breather,),
      )),
    );

Widget HomeBottomSheet(viewFunc,addFunc){
  TextStyle textStyle = TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: "Poppins",fontSize: 20);
  return Container(
    height: 140,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          leading: Icon(Icons.remove_red_eye_sharp,color: Colors.black87,),
          title: Text("VIEW",style: textStyle,),
          onTap: viewFunc,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.add,color: Colors.black87,),
          title: Text("ADD",style: textStyle,),
          onTap: addFunc,
        ),
      ],
    ),
  );
}

Widget settingBottomSheet(changePassFunc,callAdminFunc){
  TextStyle textStyle = TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: "Poppins",fontSize: 17);
  return Container(
    height: 140,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          leading: Icon(Icons.lock,color: Colors.red[700],),
          title: Text("CHANGE PASSWORD",style: textStyle,),
          onTap: changePassFunc,
        ),
        Divider(),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.phoneSquareAlt,color: Colors.greenAccent[700],),
          title: Text("CALL ADMINISTRATOR",style: textStyle,),
          onTap: callAdminFunc,
        ),
      ],
    ),
  );
}

AppBar mainAppBar(){
  return AppBar(
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("DEEPER LIFE  ",style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
        CircleAvatar(minRadius: 13,backgroundColor: Colors.white,child: Image.asset("assets/img/comLogo_round.png",fit: BoxFit.contain,width: 25,height: 25,)),
        Text("  BIBLE CHURCH",style: TextStyle(fontSize: 14,color: Colors.white),)
      ],
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.pink,
                Colors.blue
              ])
      ),
    ),
  );
}

SpeedDial memberSearchButton(listByName,listByRegion,listByDivision,listByLocation,sName,sPhone,sGender,sBranch,sRole){
  TextStyle _labelStyle = TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,fontFamily: "Poppins");
  return SpeedDial(
    childMargin: EdgeInsets.fromLTRB(0, 10, 0, 10), animatedIcon: AnimatedIcons.search_ellipsis, animatedIconTheme: IconThemeData(size: 22.0), buttonSize: 50.0,elevation: 8.0, shape: CircleBorder(),
    tooltip: 'SEARCH', backgroundColor: Colors.lightBlue, foregroundColor: Colors.white, curve: Curves.bounceInOut, overlayColor: Colors.black, overlayOpacity: 0.5,
    children: [
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.userCircle,color: Colors.amber[700],size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: '        ROLE         ',
        labelStyle: _labelStyle,
        onTap: sRole,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.globeAfrica,color: Colors.brown,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: '     LOCATION      ',
        labelStyle: _labelStyle,
        onTap: sBranch,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.restroom,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: '     GENDER       ',
        labelStyle: _labelStyle,
        onTap: sGender,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.phoneSquareAlt,size: 30,color: Colors.green[700],)),
        backgroundColor: Colors.lightBlue[100],
        label: '      PHONE        ',
        labelStyle: _labelStyle,
        onTap: sPhone,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.userAlt,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: '  FULL NAME   ',
        labelStyle: _labelStyle,
        onTap: sName,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.church,color: Colors.green,size: 30,)),
        backgroundColor: Colors.lightGreen[200],
        label: 'SORT BY LOCATION',
        labelStyle: _labelStyle,
        onTap: listByLocation,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(Icons.my_location_sharp,color: Colors.blue,size: 30,)),
        backgroundColor: Colors.lightGreen[200],
        label: 'SORT BY DIVISION',
        labelStyle: _labelStyle,
        onTap: listByDivision,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.globeAfrica,color: Colors.brown,size: 30,)),
        backgroundColor: Colors.lightGreen[200],
        label: 'SORT BY REGION',
        labelStyle: _labelStyle,
        onTap: listByRegion,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.userAlt,size: 30,)),
        backgroundColor: Colors.lightGreen[200],
        label: 'SORT BY NAME',
        labelStyle: _labelStyle,
        onTap: listByName,
      ),
    ],
  );
}

SpeedDial expectedMemberSearchButton(sName,sPhone,sGender,sRole){
  TextStyle _labelStyle = TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,fontFamily: "Poppins");
  return SpeedDial(
    childMargin: EdgeInsets.fromLTRB(0, 10, 0, 10), animatedIcon: AnimatedIcons.search_ellipsis, animatedIconTheme: IconThemeData(size: 22.0), buttonSize: 50.0,elevation: 8.0, shape: CircleBorder(),
    tooltip: 'SEARCH', backgroundColor: Colors.lightBlue, foregroundColor: Colors.white, curve: Curves.bounceInOut, overlayColor: Colors.black, overlayOpacity: 0.5,
    children: [
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.userCircle,color: Colors.amber[700],size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: '        ROLE         ',
        labelStyle: _labelStyle,
        onTap: sRole,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.restroom,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: '     GENDER       ',
        labelStyle: _labelStyle,
        onTap: sGender,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.phoneSquareAlt,size: 30,color: Colors.green[700],)),
        backgroundColor: Colors.lightBlue[100],
        label: '      PHONE        ',
        labelStyle: _labelStyle,
        onTap: sPhone,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.userAlt,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: '  FULL NAME   ',
        labelStyle: _labelStyle,
        onTap: sName,
      ),
    ],
  );
}


SpeedDial paymentSearchButton(amount,payMethod,transactID,benefactor){
  TextStyle _labelStyle = TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,fontFamily: "Poppins");
  return SpeedDial(
    childMargin: EdgeInsets.fromLTRB(0, 10, 0, 10), animatedIcon: AnimatedIcons.search_ellipsis, animatedIconTheme: IconThemeData(size: 22.0), buttonSize: 50.0,elevation: 8.0, shape: CircleBorder(),
    tooltip: 'SEARCH', backgroundColor: Colors.lightBlue, foregroundColor: Colors.white, curve: Curves.bounceInOut, overlayColor: Colors.black, overlayOpacity: 0.5,
    children: [
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.userAlt,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: ' BENEFACTOR ',
        labelStyle: _labelStyle,
        onTap: benefactor,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.idCard,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: 'TRANSACT-ID ',
        labelStyle: _labelStyle,
        onTap: transactID,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.receipt,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: ' PAY-METHOD ',
        labelStyle: _labelStyle,
        onTap: payMethod,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.moneyBillAlt,size: 30)),
        backgroundColor: Colors.lightBlue[100],
        label: '     AMOUNT     ',
        labelStyle: _labelStyle,
        onTap: amount,
      ),
    ],
  );
}

SpeedDial expenseSearchButton(amount,payMethod,transactID,benefactor,purpose){
  TextStyle _labelStyle = TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,fontFamily: "Poppins");
  return SpeedDial(
    childMargin: EdgeInsets.fromLTRB(0, 10, 0, 10), animatedIcon: AnimatedIcons.search_ellipsis, animatedIconTheme: IconThemeData(size: 22.0), buttonSize: 50.0,elevation: 8.0, shape: CircleBorder(),
    tooltip: 'SEARCH', backgroundColor: Colors.lightBlue, foregroundColor: Colors.white, curve: Curves.bounceInOut, overlayColor: Colors.black, overlayOpacity: 0.5,
    children: [
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.solidStar,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: '    PURPOSE     ',
        labelStyle: _labelStyle,
        onTap: purpose,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.userAlt,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: ' BENEFACTOR ',
        labelStyle: _labelStyle,
        onTap: benefactor,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.idCard,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: 'TRANSACT-ID ',
        labelStyle: _labelStyle,
        onTap: transactID,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.receipt,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: ' PAY-METHOD ',
        labelStyle: _labelStyle,
        onTap: payMethod,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.moneyBillAlt,size: 30)),
        backgroundColor: Colors.lightBlue[100],
        label: '     AMOUNT     ',
        labelStyle: _labelStyle,
        onTap: amount,
      ),
    ],
  );
}

SpeedDial newsSearchButton(heading,branch){
  TextStyle _labelStyle = TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,fontFamily: "Poppins");
  return SpeedDial(
    childMargin: EdgeInsets.fromLTRB(0, 10, 0, 10), animatedIcon: AnimatedIcons.search_ellipsis, animatedIconTheme: IconThemeData(size: 22.0), buttonSize: 50.0,elevation: 8.0, shape: CircleBorder(),
    tooltip: 'SEARCH', backgroundColor: Colors.lightBlue, foregroundColor: Colors.white, curve: Curves.bounceInOut, overlayColor: Colors.black, overlayOpacity: 0.5,
    children: [
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.globeAfrica,size: 30,color: Colors.brown,)),
        backgroundColor: Colors.lightBlue[100],
        label: '   LOCATION   ',
        labelStyle: _labelStyle,
        onTap: branch,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.heading,size: 30,)),
        backgroundColor: Colors.lightBlue[100],
        label: '   HEADING   ',
        labelStyle: _labelStyle,
        onTap: heading,
      ),
    ],
  );
}

SpeedDial registerSearchButton(listByDate,listByBranch,date,branch,purpose){
  TextStyle _labelStyle = TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,fontFamily: "Poppins");
  return SpeedDial(
    childMargin: EdgeInsets.fromLTRB(0, 10, 0, 10), animatedIcon: AnimatedIcons.search_ellipsis, animatedIconTheme: IconThemeData(size: 22.0), buttonSize: 50.0,elevation: 8.0, shape: CircleBorder(),
    tooltip: 'SEARCH', backgroundColor: Colors.lightBlue, foregroundColor: Colors.white, curve: Curves.bounceInOut, overlayColor: Colors.black, overlayOpacity: 0.5,
    children: [
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.solidStar,size: 30,color:Colors.amber,)),
        backgroundColor: Colors.lightBlue[100],
        label: '    PURPOSE     ',
        labelStyle: _labelStyle,
        onTap: purpose,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.globeAfrica,size: 30,color: Colors.brown,)),
        backgroundColor: Colors.lightBlue[100],
        label: '   LOCATION   ',
        labelStyle: _labelStyle,
        onTap: branch,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.calendarAlt,color:Colors.pinkAccent,size: 30)),
        backgroundColor: Colors.lightBlue[100],
        label: '   DATE   ',
        labelStyle: _labelStyle,
        onTap: date,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.globeAfrica,color: Colors.brown,size: 30,)),
        backgroundColor: Colors.lightGreen[200],
        label: 'SORT BY LOCATION',
        labelStyle: _labelStyle,
        onTap: listByBranch,
      ),
      SpeedDialChild(
        child: Center(child: FaIcon(FontAwesomeIcons.calendarAlt,color:Colors.pinkAccent,size: 30,)),
        backgroundColor: Colors.lightGreen[200],
        label: 'SORT BY DATE',
        labelStyle: _labelStyle,
        onTap: listByDate,
      ),
    ],
  );
}
