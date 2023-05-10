import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studymate/provider/AuthService.dart';
import 'package:studymate/provider/authentication.dart';
import 'package:studymate/screens/Authenticated/profilePage/updateInterest.dart';
import 'package:studymate/screens/Login/login.dart';
import 'package:studymate/service/storage_service.dart';
import 'package:path/path.dart' as p;

import '../../../models/user.dart';

class OwnProfilePage extends StatefulWidget {
  @override
  State<OwnProfilePage> createState() => _OwnProfilePageState();
}

class _OwnProfilePageState extends State<OwnProfilePage> {
  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No image selected')));
        return;
      }
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);

      if (img == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No image cropped')));
        return;
      }

      final path = img.path;
      final extension = p.extension(path); // '.jpg'

      final fileName = user.uid + extension;
      final Storage storage = Storage();

      storage.uploadProfilePicture(path, fileName).then((value) =>
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'profileImage': 'profilePictures/$fileName'}));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Image loaded')));
      setState(() {
        _image = img;
      });
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 1080,
      maxWidth: 1080,
      compressQuality: 30,
    );
    if (croppedImage == null) {
      return null;
    }
    return File(croppedImage.path);
  }

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
    final Storage storage = Storage();

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
                      child: _image == null
                          ? FutureBuilder(
                              future: storage.downloadURL(us.profileImageURL),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Something went wrong!");
                                } else if (snapshot.hasData) {
                                  return Image(
                                    image: NetworkImage(snapshot.data!),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              })
                          : Image(
                              image: FileImage(_image!),
                            ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.mode_edit_outline),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(16),
                            child: Stack(
                              alignment: AlignmentDirectional.topCenter,
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                    top: -10,
                                    child: Container(
                                      width: 59,
                                      height: 3,
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.5),
                                        color: Colors.black38,
                                      ),
                                    )),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                        onPressed: (() {
                                          _pickImage(ImageSource.gallery);
                                          return;
                                        }),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.collections_outlined),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text('Browse Gallery'),
                                          ],
                                        )),
                                    Text('or'),
                                    ElevatedButton(
                                        onPressed: (() {
                                          _pickImage(ImageSource.camera);
                                          return;
                                        }),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.camera_alt_outlined),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text('Use a Camera'),
                                          ],
                                        )),
                                  ],
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
