import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FirebaseServicesStorage {
  final ref = FirebaseDatabase.instance.ref();

  Future<String> uploadPhoto(File? photo, String name) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('App-Spend/UsersPath/name.jpg');
      UploadTask uploadTask = ref.putFile(photo!);
      final downUrl = await (await uploadTask).ref.getDownloadURL();
      return downUrl.toString();
    } on FirebaseException catch (e) {
      print(e.message.toString());
      return "";
    }
  }
}
