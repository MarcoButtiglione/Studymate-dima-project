import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studymate/screens/Authenticated/authenticated.dart';
import 'package:studymate/screens/Login/login.dart';

import '../screens/Login/setUser.dart';

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

      final list =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(_user!.email);
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (list.isNotEmpty) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Authenticated()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SetUser()));
      }
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
