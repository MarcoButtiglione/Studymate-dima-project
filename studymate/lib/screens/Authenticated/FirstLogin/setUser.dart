import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studymate/component/storage.dart';
import 'package:studymate/screens/Authenticated/FirstLogin/intrest.dart';
import 'package:file_picker/file_picker.dart';

import '../../../component/utils.dart';
import '../../../models/user.dart';

class SetUser extends StatefulWidget {
  @override
  _SetUserState createState() => _SetUserState();
}

class _SetUserState extends State<SetUser> {
  final formKey = GlobalKey<FormState>();
  final firstnameControler = TextEditingController();
  final lastnameControler = TextEditingController();
  final Storage storage = Storage();
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
    double h = size.height;
    double w = size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Column(children: <Widget>[
                  SizedBox(
                    height: h > w
                        ? w * 0.3
                        : (h > 720 && w > 490)
                            ? 0.1 * h
                            : 0,
                  ),
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontFamily: "Crimson Pro",
                      fontWeight: FontWeight.bold,
                      fontSize: (w > 490 && h > 720) ? 60 : 35,
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
                            //child: Image.network(imgUrl)),
                            child: Image.asset("assets/login/user.png")),
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
                              //imgUrl = storage.downloadFile(user.uid) as String;
                            }
                          },
                          style: IconButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
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
                    width: w * 0.8,
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: firstnameControler,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle:
                            TextStyle(fontSize: (w > 490 && h > 720) ? 25 : 14),
                        hintStyle:
                            TextStyle(fontSize: (w > 490 && h > 720) ? 16 : 12),
                        errorStyle:
                            TextStyle(fontSize: (w > 490 && h > 720) ? 16 : 12),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.isEmpty
                          ? 'Enter valid Name'
                          : null,
                      style:
                          TextStyle(fontSize: (w > 490 && h > 720) ? 25 : 14),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    width: w * 0.8,
                    child: TextFormField(
                      controller: lastnameControler,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Surname",
                        labelStyle:
                            TextStyle(fontSize: (w > 490 && h > 720) ? 25 : 14),
                        hintStyle:
                            TextStyle(fontSize: (w > 490 && h > 720) ? 16 : 12),
                        errorStyle:
                            TextStyle(fontSize: (w > 490 && h > 720) ? 16 : 12),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.isEmpty
                          ? 'Enter valid Surname'
                          : null,
                      style:
                          TextStyle(fontSize: (w > 490 && h > 720) ? 25 : 14),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 0.03 * h, left: 0.03 * h, right: 0.03 * h),
                    height: 0.08 * h,
                    width: 0.8 * w,
                    child: ElevatedButton(
                        onPressed: setProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 233, 64, 87),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (w > 490 && h > 720) ? 30 : 16,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        )),
                  ),
                ]),
              ],
            ),
          ),
        ));
  }

  Future setProfile() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      final addUser = Users(
          id: user.uid,
          firstname: firstnameControler.text.trim(),
          lastname: lastnameControler.text.trim(),
          profileImageURL:
              'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80',
          userRating: 0,
          hours: 20,
          numRating: 0);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Intrest(addUser: addUser)));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
