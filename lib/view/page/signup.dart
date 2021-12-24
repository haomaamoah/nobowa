

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:nobowa/controller/validation.dart';
import 'package:nobowa/view/widget/bouncy_page_route.dart';
import 'verifyotp.dart';
import '../widget/accessories.dart';
import '../widget/dialogs.dart';
import '../../model/models.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart' as l;




class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  Users user = Users();
  String? location;
  late String dialCode;
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  late Timestamp timestamp;
  late l.LocationData position;
  final l.Location _location = l.Location();
  late l.PermissionStatus _permissionGranted;

  static List<String> professionOpt = ["CHOOSE YOUR PROFESSION",...Utils.professions];
  String profession = professionOpt[0];




  TextStyle headingStyle1 = const TextStyle(
      fontSize: 30,fontFamily: "Poppins",
      fontWeight: FontWeight.w800,color: Utils.brownColor
  );

  TextStyle headingStyle2 = const TextStyle(
      fontSize: 25,fontFamily: "Poppins",
      fontWeight: FontWeight.w800,color: Utils.brownColor
  );

  EdgeInsets infoPadding = const EdgeInsets.fromLTRB(35, 20, 35, 20);
  OutlineInputBorder infoOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  );

  void validate()async {
    if (_formKey.currentState!.validate()){
      print('validated');setState(()=>loading=!loading);

      user.name=name.text;
      user.password=password.text;
      user.email=email.text;
      String formattedPhone = (phone.text.startsWith("0") && phone.text.length >= 10)? phone.text.substring(1,) : phone.text;
      user.phone=dialCode+formattedPhone;
      user.location=location ?? "Not Found";
      user.profession=profession;
      user.timestamp=Timestamp.now();
      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>VerifyOTPForm(user)));
      setState(()=>loading=!loading);
    }

  }



  // GET AND SET CURRENT GPS LOCATION
  getCurrentLocation()async{
    _permissionGranted = await _location.requestPermission();

    if (_permissionGranted == PermissionStatus.granted || _permissionGranted == PermissionStatus.grantedLimited) {
      position = await _location.getLocation();
      final coordinates = Coordinates(position.latitude, position.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      location = "${first.addressLine} Lat: ${position.latitude} Lng: ${position.longitude}";

    }else{
      Navigator.of(context).pop();
      statusDialog(context,false,"PLEASE ENABLE LOCATION!");
    }


  }




  // Full Name
  Widget _name(){
    return Padding(
      padding: infoPadding,
      child: TextFormField(
        controller: name,
        decoration: InputDecoration(
            border: infoOutlineInputBorder,labelStyle: const TextStyle(color: Utils.brownColor,fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
            labelText: "FULL NAME",icon: const FaIcon(FontAwesomeIcons.userAlt,color: Colors.blueGrey,)),
        validator: validateName,
      ),
    );
  }
  // Email
  Widget _email(){
    return Padding(
      padding: infoPadding,
      child: TextFormField(
        controller: email,
        decoration: InputDecoration(
            labelStyle: const TextStyle(color: Utils.brownColor,fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
            border: infoOutlineInputBorder,labelText: "EMAIL",icon: const FaIcon(Icons.mail,size: 30,color: Colors.blueGrey,)),
        validator: validateEmail,
      ),
    );
  }
  // Phone Field
  Widget _phone(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                textStyle: TextStyle(color: Utils.brownColor,fontSize: 20,fontFamily: "Times New Roman",fontWeight: FontWeight.w600),
                flagDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 150,
            child: TextFormField(
              controller: phone,keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                hintStyle: TextStyle(color: Utils.brownColor,fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
                hintText: "ENTER MOBILE",
              ),
              validator: validatePhone,
            ),
          ),
        ],
      ),
    );
  }
  // Password
  Widget _password(){
    return Padding(
      padding: infoPadding,
      child: TextFormField(
        controller: password,
        obscureText: true,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            errorStyle: const TextStyle(fontSize: 13,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
            labelStyle: const TextStyle(color: Utils.brownColor,fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
            border: infoOutlineInputBorder,labelText: "PASSWORD",icon: FaIcon(Icons.lock,color: Colors.red,size: 28,)
        ),
        validator: validateSignupPassword,
      ),
    );
  }
  // Profession
  Widget _profession(){
    return Padding(
      padding: infoPadding,
      child: Container(
        height: 60,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: const BorderRadius.all(
              Radius.circular(15.0) //                 <--- border radius here
          ),
        ),
        child: DropdownButton(
          dropdownColor: Colors.white,
          value: profession,
          items: professionOpt.map((professionName) {
            return DropdownMenuItem(value: professionName,
              child: Row(children: <Widget>[
                if(professionName!="CHOOSE YOUR PROFESSION")FaIcon(FontAwesomeIcons.idCard,size: 20,color: Colors.black,),
                const SizedBox(width: 20,),
                Text(professionName,style: const TextStyle(
                    fontFamily: "Times New Roman",
                    fontSize: 15,color: Utils.brownColor,fontWeight: FontWeight.bold),)
              ],),
            );
          }).toList(),
          onChanged: (professionName)=>setState(()=>profession = professionName.toString()),
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
                children: [
                  const SizedBox(height:20),
                  Image.asset(Utils.iconLogo,fit: BoxFit.contain,width: 100,height: 100,),
                  Text("NOBOWA.com",textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16,color: Utils.brownColor,fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Sign Up",
                            style: headingStyle2,
                          ),
                          VerticalDivider(thickness: 4,color: Utils.brownColor,),
                          GestureDetector(
                            onTap: ()=>Navigator.of(context).pop(),
                            child: const Text.rich(
                                TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Are you a member?",
                                          style: TextStyle(
                                              color: Colors.black54,fontFamily: "Times New Roman",
                                              fontWeight: FontWeight.w900,fontSize: 14.0
                                          )
                                      ),
                                      TextSpan(
                                          text: " LOGIN",
                                          style: TextStyle(
                                              color: Colors.blue,fontFamily: "Times New Roman",
                                              fontWeight: FontWeight.w900,fontSize: 14.0
                                          )
                                      )
                                    ]
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  _name(),
                  _email(),
                  _password(),
                  _profession(),
                  _phone(),
                  GestureDetector(
                    onTap: ()async{
                      if (profession!="CHOOSE YOUR PROFESSION"){
                        if (location==null)await getCurrentLocation();
                        validate();
                      }else{
                        statusDialog(context, false,"CHOOSE A PROFESSION!");
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFffec00),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(child: Text('Sign Up',style: TextStyle(color: Utils.brownColor,fontFamily: "Times New Roman",fontWeight: FontWeight.w800,fontSize: 22),)),
                        ),
                      ),
                    ),
                  ),

                ]
            ),
          ),
          (loading)?Center(child: GradientCirclePBar()): const SizedBox(),
        ],
      ),
    );
  }
}
