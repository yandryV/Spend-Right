import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _pref;

  Future init() async {
    _pref = await SharedPreferences.getInstance();
  }

  // GET y SET del user
  String get user {
    return _pref.getString('user') ?? '';
  }

  set user(String value) {
    _pref.setString('user', value);
  }
}
