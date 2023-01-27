import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studymate/component/storage.dart';
import 'package:studymate/screens/Authenticated/authenticated.dart';
import 'package:file_picker/file_picker.dart';
import '../../component/utils.dart';
import '../../models/user.dart';

class SetUser extends StatefulWidget {
  @override
  _SetUserState createState() => _SetUserState();
}

class _SetUserState extends State<SetUser> {
  final firstnameControler = TextEditingController();
  final lastnameControler = TextEditingController();
  final Storage storage = Storage();
  late String filename = "user.png";
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void dispose() {
    firstnameControler.dispose();
    lastnameControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Welcome",
            style: TextStyle(
              fontFamily: "Crimson Pro",
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Color.fromARGB(255, 233, 64, 87),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              SizedBox(
                height: 150,
                width: 150,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                        storage.downloadFile(filename) as String)),
              ),
              IconButton(
                  icon: const Icon(Icons.photo_camera),
                  onPressed: () async {
                    final results = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg']);
                    if (results == null) {
                      Utils.showSnackBar('No file selected');
                    } else {
                      final path = results.files.single.path!;
                      storage.uploadFile(path, user.uid);
                      filename = user.uid;
                    }
                  },
                  style: IconButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: firstnameControler,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: "Name"),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: lastnameControler,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: "Surname"),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40.0),
            width: 300,
            child: ElevatedButton(
                onPressed: setProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 233, 64, 87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  padding: (size.width <= 550)
                      ? const EdgeInsets.symmetric(horizontal: 70, vertical: 20)
                      : const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 25),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                )),
          ),
        ]));
  }

  Future setProfile() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      final docUser = FirebaseFirestore.instance.collection('users').doc();
      final addUser = Users(
          id: user.uid,
          firstname: firstnameControler.text.trim(),
          lastname: lastnameControler.text.trim(),
          profileImageURL: filename);
      final json = addUser.toJson();
      await docUser.set(json);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Authenticated()));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
