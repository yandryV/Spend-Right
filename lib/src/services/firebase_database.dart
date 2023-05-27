import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spend_right/src/models/user_model.dart';

DatabaseReference _ref = FirebaseDatabase.instance.ref();
final CollectionReference _usersCollection =
    FirebaseFirestore.instance.collection('users');

class FirebaseServicesDatabase {
// USER
  Future<UserModel> getUserData(String uid) async {
    UserModel user = UserModel().init();
    final id = uid.replaceAll(".", "-");
    final snapshot = await _usersCollection.doc(id).get();
    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null) {
        final Map<String, dynamic> decodedData =
            Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
        user = UserModel.fromJson(decodedData);
      }
    }
    return user;
  }

  Future<bool> postUserData(UserModel user) async {
    if (user.uid != '') {
      await _usersCollection.doc(user.uid).set(user.toJson());
      return true;
    }
    return false;
  }

// CONFIG
  // Terms
  // Future<String> getTernsAndConditions() async {
  //   final snapshot =
  //       await _ref.child('Spend/Information/TermsAndConditions').get();
  //   String data = '';
  //   if (snapshot.exists) {
  //     data = snapshot.value.toString();
  //   }
  //   return data;
  // }
}
