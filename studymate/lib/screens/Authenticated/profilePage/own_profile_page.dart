import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studymate/provider/authentication.dart';
import 'package:studymate/screens/Authenticated/profilePage/updateInterest.dart';
import 'package:studymate/service/storage_service.dart';
import 'package:path/path.dart' as p;

import '../../../../models/user.dart';

enum ProfilePageSection { onwlesson, saved}

class OwnProfilePage extends StatefulWidget {
  @override
  State<OwnProfilePage> createState() => _OwnProfilePageState();
}

class _OwnProfilePageState extends State<OwnProfilePage> {
  File? _image;
  ProfilePageSection selected = ProfilePageSection.onwlesson;

  

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
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
              future: storage.downloadURL('Categories/Biomedical.jpg'),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong!");
                } else if (snapshot.hasData) {
                  return Image(
                    fit: BoxFit.fill,
                    image: NetworkImage(snapshot.data!),
                  );
                } else {
                  return Container();
                }
              }),
        ),
        //Sfumatura
        Positioned(
            top: 170,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.background.withOpacity(0),
                    Theme.of(context).colorScheme.background
                  ],
                ),
                color: Theme.of(context).colorScheme.background,
              ),
              width: MediaQuery.of(context).size.width,
              height: 111,
            )),
        Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
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
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.5),
                                            color: Colors.black38,
                                          ),
                                        )),
                                    Wrap(
                                      children: [
                                        ListTile(
                                          onTap: () {},
                                          leading: const Icon(Icons.settings),
                                          title: const Text('Edit profile'),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        updateInterest(
                                                          interest: interest,
                                                        )));
                                          },
                                          leading: const Icon(Icons.favorite),
                                          title: const Text('Edit preferences'),
                                        ),
                                        ListTile(
                                          onTap: () {},
                                          leading: const Icon(Icons.schedule),
                                          title: const Text('Edit timeslots'),
                                        ),
                                        _isSigningOut
                                            ? CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color.fromARGB(
                                                            255, 233, 64, 87)),
                                              )
                                            : ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    _isSigningOut = true;
                                                  });
                                                  Authentication
                                                      .signOutWithGoogle(
                                                          context: context);
                                                  setState(() {
                                                    _isSigningOut = true;
                                                  });
                                                },
                                                leading:
                                                    const Icon(Icons.logout),
                                                title: const Text('Logout'),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                              color: Color.fromARGB(211, 255, 255, 255),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Center(
                                  child: Icon(
                                    Icons.menu,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),

        //BODY
        Positioned(
          top: 280,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 130,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 200,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: _image == null
                                  ? FutureBuilder(
                                      future: storage
                                          .downloadURL(us.profileImageURL),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              "Something went wrong!");
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
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2.5),
                                                color: Colors.black38,
                                              ),
                                            )),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                                onPressed: (() {
                                                  _pickImage(
                                                      ImageSource.gallery);
                                                  return;
                                                }),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(Icons
                                                        .collections_outlined),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text('Browse Gallery'),
                                                  ],
                                                )),
                                            Text('or'),
                                            ElevatedButton(
                                                onPressed: (() {
                                                  _pickImage(
                                                      ImageSource.camera);
                                                  return;
                                                }),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(Icons
                                                        .camera_alt_outlined),
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
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${us.firstname} ${us.lastname}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
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
