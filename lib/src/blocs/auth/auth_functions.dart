List<bool> validarCorreo(String email, bool passwordState) {
  email = email.replaceAll(' ', '');
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern.toString());

  if (regExp.hasMatch(email)) {
    return [true, loginButtonValidator(true, passwordState)];
  } else {
    return [false, false];
  }
}

bool loginButtonValidator(bool email, bool password) {
  if (email && password) {
    return true;
  } else {
    return false;
  }
}

List<bool> passwordValidator(String password, bool emailState){
  if (password.length>= 6) {
    return [true, loginButtonValidator(true, emailState)];
  } else{
    return [false, false];
  }
}

bool confirmPasswordValidator(String password, String confirmPassword) {
  if (password == confirmPassword) {
    return true;
  } else {
    return false;
  }
}