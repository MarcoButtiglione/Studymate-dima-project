import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../component/utilities.dart';
import '../component/utils.dart';
import '../screens/Authenticated/authenticated.dart';

class Authentication {
  //this method is used to initialize firebase
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  //this method is used to rertrive the current user
  static Future<User?> getCurrentUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    await firebaseUser?.reload();
    return firebaseUser;
  }

  //this method is used to perform the signInWithGoogle
  static Future<void> signInWithGoogle({required BuildContext context}) async {
    Utilities utilities = Utilities();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          await auth.signInWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            utilities.showAlertDialog(context, "Attention!",
                "The account already exists with a different credential");
          } else if (e.code == 'invalid-credential') {
            utilities.showAlertDialog(context, "Attention!",
                "Error occurred while accessing credentials. Try again.");
          }
        } catch (e) {
          utilities.showAlertDialog(context, "Attention!",
              "Error occurred using Google Sign In. Try again.");
        }
      }
    }
  }

  //this method is used to perform the signOutWithGoogle
  static Future<void> signOutWithGoogle({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    Utilities utilities = Utilities();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      utilities.showAlertDialog(
          context, "Attention!", "Error signing out. Try again.");
    }
  }
}