import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studymate/screens/Authenticated/authenticated.dart';
import 'package:studymate/screens/Login/login.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future googleLogin(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Authenticated()));
    } on Exception catch (e) {
      print(e);
      //Navigator.of(context).pop();
    }
    notifyListeners();
  }

  Future logout() async {
    FirebaseAuth.instance.signOut();
    if (await googleSignIn.isSignedIn()) {
      googleSignIn.disconnect();
    }

    //Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }
}
