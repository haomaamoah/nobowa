import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nobowa/controller/validation.dart';
import 'package:nobowa/model/models.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/file_utils.dart';
import 'bouncy_page_route.dart';

logoutDialog(BuildContext context,page){
  String alert =  'Are you sure you want to LOGOUT?';
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      actionsPadding: const EdgeInsets.symmetric(vertical:5.0,horizontal:10.0),
      title: const Icon(Icons.login_outlined,size: 60,color: Colors.red,),
      content: SizedBox(width: 50,child: Text(alert,
        textAlign: TextAlign.center,style: const TextStyle(fontFamily: "Arial",fontSize: 30,fontWeight: FontWeight.w500),),),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
            ),
                child:MaterialButton(elevation: 5.0,child: const Text('CANCEL',
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                ),
                    onPressed: () => Navigator.of(context).pop(false)
                )),
            const SizedBox(width: 10,),
            Container(height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.redAccent
            ),
                child:MaterialButton(elevation: 5.0,child: const Text('LOGOUT',
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                ),
                    onPressed: (){
                      FileUtils.deleteFile();
                      Navigator.of(context).pushReplacement(BouncyPageRoute(widget: page));
                    }
                ))
          ],
        )
      ],
    );
  });}

nonUserDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      title: const Center(child: Icon(Icons.lock,size: 60,color: Colors.red,)),
      content: const Text('Login was unsuccessful!'),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: const Text('TRY AGAIN',
            style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.w700),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  });}

noInternetDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.satelliteDish,size: 60,color: Colors.red,)),
      content: Text('Failed! No Internet Connection.'),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text('TRY AGAIN',
            style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.w700),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  });
}

statusDialog(BuildContext context,bool status,String label){
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      title: Center(child: FaIcon((status)?FontAwesomeIcons.checkCircle:Icons.block,size: 60,color: (status)?Colors.green:Colors.red,)),
      content: Text(label,textAlign: TextAlign.center,),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text((status)?'OK':'TRY AGAIN',
            style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.w700),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  });
}


Future searchPhoneDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchPhonePopUp();
  });
}

class searchPhonePopUp extends StatefulWidget {
  @override
  _searchPhonePopUpState createState() => _searchPhonePopUpState();
}
class _searchPhonePopUpState extends State<searchPhonePopUp> {
  OutlineInputBorder infoOutlineInputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(20),);
  TextEditingController phone = TextEditingController();
  late String dialCode;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.phoneSquareAlt,size: 27,color: Colors.green,)),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: (){
                        if (phone.text.isEmpty){
                          Navigator.of(context).pop();
                        }
                        else{
                          String formattedPhone = (phone.text[0] == "0" && phone.text.length >= 10)? phone.text.substring(1,) : phone.text;
                          Navigator.of(context).pop(dialCode+formattedPhone);
                        }

                      }
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop(false)
                  ))
            ],
          ),
        )
      ],
    );
  }
}


externalLinkDialog(BuildContext context,url){
  String alert =  'This link leads to an external website.\nPROCEED?';
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      actionsPadding: const EdgeInsets.symmetric(vertical:5.0,horizontal:10.0),
      title: Center(child: const FaIcon(FontAwesomeIcons.globeAfrica,size: 60,color: Utils.brownColor,)),
      content: SizedBox(width: 50,child: Text(alert,
        textAlign: TextAlign.center,style: const TextStyle(fontFamily: "Times New Roman",fontSize: 25,fontWeight: FontWeight.w700),),),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.redAccent[100]
            ),
                child:MaterialButton(elevation: 5.0,child: const Text('NO',
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Utils.brownColor),
                ),
                    onPressed: () => Navigator.of(context).pop()
                )),
            const SizedBox(width: 10,),
            Container(height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Utils.yellowColor
            ),
                child:MaterialButton(elevation: 5.0,child: const Text('YES',
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Utils.brownColor),
                ),
                    onPressed: (){Navigator.of(context).pop;launch(url,enableJavaScript: true);}
                ))
          ],
        )
      ],
    );
  });}
