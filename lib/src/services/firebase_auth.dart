import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:spend_right/src/helpers/utils.dart';

class FirebaseServicesAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createAccount(String email, String password) async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    user!.sendEmailVerification();
    return user;
  }

  resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) {
        Navigator.of(context).pop();
        showAlert(context, 'Proceso exitoso',
            'Se ha enviado un correo electrónico para restablecer la contrasena. Si no encuentra el correo, revise su bandeja de spam');
      });
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showAlert(context, 'ERROR', e.message.toString());
      return null;
    }
  }

  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  Future signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
