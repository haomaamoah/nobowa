

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:nobowa/controller/validation.dart';
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
      fontWeight: FontWeight.w800,color: Color(0xFF4f2d01)
  );

  TextStyle headingStyle2 = const TextStyle(
      fontSize: 23,fontFamily: "Poppins",
      fontWeight: FontWeight.w800,color: Color(0xFF4f2d01)
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
      user.phone=dialCode+phone.text;
      user.location=location ?? "Not Found";
      user.profession=profession;
      user.timestamp=Timestamp.now();
      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>VerifyOTPForm(user)));
      setState(()=>loading=!loading);
    }

  }



  // GET AND SET CURRENT GPS LOCATION
  getCurrentLocation()async{
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == l.PermissionStatus.denied || _permissionGranted != l.PermissionStatus.deniedForever) {
      _permissionGranted = await _location.requestPermission();
    }

    if (_permissionGranted == PermissionStatus.granted || _permissionGranted == PermissionStatus.grantedLimited) {
      position = await _location.getLocation();
      final coordinates = Coordinates(position.latitude, position.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      location = "${first.addressLine} Lat: ${position.latitude} Lng: ${position.longitude}";
      debugPrint("${first.featureName} : ${first.addressLine}\n${position.latitude} : ${position.longitude}");

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
            border: infoOutlineInputBorder,labelStyle: const TextStyle(color: Color(0xFF4f2d01),fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
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
            labelStyle: const TextStyle(color: Color(0xFF4f2d01),fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
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
  // Password
  Widget _password(){
    return Padding(
      padding: infoPadding,
      child: TextFormField(
        controller: password,
        obscureText: true,
        decoration: InputDecoration(
            labelStyle: const TextStyle(color: Color(0xFF4f2d01),fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.bold),
            border: infoOutlineInputBorder,labelText: "PASSWORD",icon: FaIcon(Icons.lock,color: Colors.red,size: 28,)
        ),
        validator: validatePassword,
      ),
    );
  }
  // Profession
  Widget _profession(){
    return Padding(
      padding: infoPadding,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: const BorderRadius.all(
              Radius.circular(10.0) //                 <--- border radius here
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
                    fontSize: 15,color: Color(0xFF4f2d01),fontWeight: FontWeight.bold),)
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
      appBar: mainAppBar(),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
                children: [
                  const SizedBox(height:20),
                  Center(
                    child: Text(
                      "SIGNUP FORM",
                      style: headingStyle1,
                    ),
                  ),
                  Divider(thickness: 1,color: Colors.black,indent: 35,endIndent: 35,),
                  _name(),
                  _email(),
                  _password(),
                  _profession(),
                  SizedBox(height: 10,),
                  Divider(thickness: 0.3,color: Color(0xFF4f2d01),),
                  SizedBox(height: 10,),
                  Center(
                    child: Text(
                      "VERIFY YOUR CONTACT",
                      style: headingStyle2,
                    ),
                  ),
                  Divider(thickness: 1,color: Colors.black,indent: 50,endIndent: 50,),
                  SizedBox(height: 10,),
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
                          child: const Center(child: Text('VERIFY',style: TextStyle(color: Color(0xFF4f2d01),fontFamily: "Times New Roman",fontWeight: FontWeight.w800,fontSize: 25),)),
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
