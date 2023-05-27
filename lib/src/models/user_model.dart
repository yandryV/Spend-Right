import 'dart:convert';

class UserModel {
  UserModel({
    this.admin = false,
    this.email = "",
    this.photoUrl = "",
    this.uid = "",
    this.name = "",
  });

  bool admin;
  String email;
  String photoUrl;
  String uid;
  String name;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      admin: json["admin"],
      email: json["email"],
      photoUrl: json["fotoURL"],
      uid: json["id"],
      name: json["nombre"],
    );
  }

  factory UserModel.toDecodeJson(String data) {
    return UserModel.fromJson(json.decode(data));
  }

  String toEncodeJson() => json.encode({
        "admin": admin,
        "email": email,
        "fotoURL": photoUrl,
        "id": uid,
        "nombre": name,
      });
  Map<String, dynamic> toJson() => {
        "admin": admin,
        "email": email,
        "fotoURL": photoUrl,
        "id": uid,
        "nombre": name,
      };
  bool profileCompleted() {
    return 
        email != '' &&
        // TODO: Validate photo
        // photoUrl != '' &&
        uid != '' &&
        name != '';
  }

  UserModel init() {
    final userData = UserModel();
    return userData;
  }
}