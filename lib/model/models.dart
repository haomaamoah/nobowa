import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  late String name,password,email,phone,location,profession;
  late Timestamp timestamp;

  Users(name,password,email,phone,location,profession,timestamp);

  Map<String,dynamic> toMap(){
    var map = <String, dynamic>{
      'name': name,'email': email,'phone': phone,'password': password,
      'location': location,'profession': profession,'timestamp': timestamp,
    }; return map;
  }

  Users.fromMap(var map){
    name = map['name'];email = map['email'];phone = map['phone'];password = map['pwd'];
    location = map['location'];profession = map['profession'];timestamp = map['timestamp'];
  }
}


class Admin {
  String? pwd;

  Admin(this.pwd);

  Map<String,dynamic> toMap(){
    var map = <String, dynamic>{
      'pwd': pwd
    }; return map;
  }

  Admin.fromMap(Map<String, dynamic> map){
    pwd = map['pwd'];
  }
}

class DataUtils {
  static const String
  mainLogo = 'assets/img/comLogo.jpeg',
      mainLogoRound = 'assets/img/comLogo_round.png';
  static const List<String>
  roles = ["CHOIR","ORCHESTRA","C & O"],
      genders = ["MALE","FEMALE"],
      sections = ["CHILD","YOUTH","ADULT","LEADER-CH","LEADER-YTH","LEADER-ALL",],
      professions = ["ACCRA","BIBIANI","BOLGA","CAPE COAST","GOASO","HO","HOHOE","KOFORIDUA", "KONONGO","KUMASI NORTH",
        "KUMASI SOUTH","MADINA","MAMPONG","NKAWIE","OBUASI","SUNYANI","TAKORADI","TAMALE","TARKWA","TECHIMAN","TEMA","WA"];
}
