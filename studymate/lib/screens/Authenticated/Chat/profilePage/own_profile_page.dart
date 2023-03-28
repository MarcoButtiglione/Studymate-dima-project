import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:studymate/provider/AuthService.dart';
import 'package:studymate/provider/authentication.dart';
import 'package:studymate/screens/Authenticated/Chat/profilePage/updateInterest.dart';
import 'package:studymate/screens/Login/login.dart';

import '../../../../models/user.dart';

class OwnProfilePage extends StatefulWidget {
  @override
  State<OwnProfilePage> createState() => _OwnProfilePageState();
}

class _OwnProfilePageState extends State<OwnProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    Stream<List<Users>> readUsers() => FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());
    return FutureBuilder(
        future: readUsers().first,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong!');
          } else if (snapshot.hasData) {
            var users = snapshot.data!;

            return _buildPage(users.first);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildPage(Users us) {
    List<String> interest = [];
    us.categoriesOfInterest!.forEach((element) {
      interest.add(element.toString());
    });
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Profile details", style: TextStyle(fontSize: 35)),
              const SizedBox(height: 50),
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: NetworkImage(us.profileImageURL),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.photo_camera),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FlutterLogo(size: 120),
                                const FlutterLogo(size: 120),
                                const FlutterLogo(size: 120),
                                ElevatedButton(
                                  child: const Text("Close"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        disabledBackgroundColor: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.12),
                        hoverColor: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.08),
                        focusColor: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.12),
                        highlightColor: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.12),
                      )),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      enabled: false,
                      initialValue: us.firstname,
                      decoration: InputDecoration(
                        labelText: "First name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      enabled: false,
                      initialValue: us.lastname,
                      decoration: InputDecoration(
                        labelText: "Last name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => updateInterest(
                                    interest: interest,
                                  )));
                    },
                    child: const Text("Modify your interests",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              _isSigningOut
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 233, 64, 87)),
                    )
                  : Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSigningOut = true;
                          });
                          Authentication.signOutWithGoogle(context: context);
                          setState(() {
                            _isSigningOut = true;
                          });
                        },
                        child: const Text("Logout",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 233, 64, 87))),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  /*logout() async {
    FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>['email'],
    );
    if (await googleSignIn.isSignedIn()) {
      googleSignIn.signOut();
    }
  }*/
}
