// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:nobowa/model/models.dart';
// import 'package:nobowa/view/page/splash.dart';
// import 'package:nobowa/view/page/login.dart';
// import 'package:nobowa/view/widget/dialogs.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//   Future<void> launchWebsite() => launch('https://nobowa.com',enableDomStorage: true,forceWebView: true,enableJavaScript: true,);
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     launchWebsite();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: ()=>logoutDialog(context, const LoginForm()),
//       child: GestureDetector(
//         onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SplashScreen())),
//         child: Container(
//           width: double.infinity,height: double.infinity,
//           color: Colors.white,
//           child: Center(
//             child: Image.asset(Utils.iconLogo,fit: BoxFit.cover,),
//           ),
//         ),
//       ),
//     );
//   }
// }
