import 'package:characters/src/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

final cloud = FirebaseFirestore.instance;
final users = cloud.collection('users');

class UsersDB{
  static Stream<QuerySnapshot> getAllUsers([String? userID]){
    return users
        .orderBy('name')
        .snapshots();
  }


  static Future<void> addUser(Users u) async {
    return users.doc(u.phone).set(u.toMap());
  }

  static Future<QuerySnapshot> validUser(String phone){
    return users.where("phone",isEqualTo: phone).get();
  }

  static Future<void> updatePassword(Users u) async {
    DocumentReference user = users.doc(u.phone);
    return user.update({'password':u.password});
  }
}