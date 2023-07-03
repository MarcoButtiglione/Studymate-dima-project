import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studymate/provider/authentication.dart';
import 'package:studymate/screens/Authenticated/profilePage/components/body_profile_page.dart';
import 'package:studymate/screens/Authenticated/profilePage/components/edit_timeslots_page.dart';
import 'package:studymate/screens/Authenticated/profilePage/updateInterest.dart';
import 'package:studymate/service/storage_service.dart';
import 'package:path/path.dart' as p;

import '../../../../models/user.dart';
import '../../../functions/routingAnimation.dart';
import '../../../models/category.dart';
import '../../../models/timeslot.dart';
import '../hoursselection_page.dart';

class OwnProfilePage extends StatefulWidget {
  @override
  State<OwnProfilePage> createState() => _OwnProfilePageState();
}

class _OwnProfilePageState extends State<OwnProfilePage> {
  File? _image;

  @override
  void initState() {
    super.initState();
  }

  Stream<List<Category>> readCategory(String category) => FirebaseFirestore
      .instance
      .collection('categories')
      .where('name', isEqualTo: category)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());

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
    Stream<List<TimeslotsWeek>> readTimeslot() => FirebaseFirestore.instance
        .collection('timeslots')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TimeslotsWeek.fromJson(doc.data()))
            .toList());

    return StreamBuilder(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong!');
          } else if (snapshot.hasData) {
            var users = snapshot.data!;

            return StreamBuilder(
                stream: readTimeslot(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong!');
                  } else if (snapshot.hasData) {
                    var timeslots = snapshot.data!;

                    return _buildPage(users.first, timeslots);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildPage(Users us, List<TimeslotsWeek> ts) {
    final Storage storage = Storage();

    List<String> interest = [];
    us.categoriesOfInterest!.forEach((element) {
      interest.add(element.toString());
    });
    int randNum = Random().nextInt(100);
    String randomCategory =
        us.categoriesOfInterest![randNum % us.categoriesOfInterest!.length];
    return Stack(
      children: [
        /*===IMMAGINE DI SFONDO===*/
        Positioned(
          top: 0,
          left: 0,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<List<Category>>(
              stream: readCategory(randomCategory),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong!");
                } else if (snapshot.hasData) {
                  final category = snapshot.data!.first;
                  return FutureBuilder(
                      future: storage.downloadURL(category.imageURL),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong!");
                        } else if (snapshot.hasData) {
                          return Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(snapshot.data!),
                          );
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              margin: EdgeInsets.zero,
                            ),
                          );
                        }
                      });
                } else {
                  return const Center(
                      //child: CircularProgressIndicator(),
                      );
                }
              })),
        ),
        /*===SFUMATURA SFONDO===*/
        Positioned(
          top: 110,
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
          ),
        ),
        /*===BOTTONI SUPERIORI===*/
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
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    us.hours.toString(),
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.av_timer,
                                    size: 40,
                                  ),
                                ],
                              ),
                              content: Text(
                                  'You have ${us.hours} hours available to spend on other lessons. Finish some lessons or create new ones to get more.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Close'),
                                  child: const Text('Close'),
                                ),
                              ],
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(us.hours.toString()),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.av_timer,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            showDragHandle: true,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Container(
                              child: Wrap(
                                children: [
                                  /*
                                  ListTile(
                                    onTap: () {},
                                    leading: const Icon(Icons.settings),
                                    title: const Text('Edit profile'),
                                  ),
                                   */

                                  ListTile(
                                    onTap: () {
                                      Navigator.pop(
                                          context, 'Edit preferences');
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
                                  (() {
                                    if (ts.isEmpty) {
                                      return ListTile(
                                        onTap: () {
                                          Navigator.pop(
                                              context, 'Insert timeslots');
                                          Navigator.of(context).push(
                                              createRoute(
                                                  const HoursSelectionPage()));
                                          return;
                                        },
                                        leading: const Icon(Icons.schedule),
                                        title: const Text('Insert timeslots'),
                                      );
                                    } else {
                                      return ListTile(
                                        onTap: () {
                                          Navigator.pop(
                                              context, 'Edit timeslots');
                                          Navigator.of(context).push(
                                              createRoute(EditTimeslotsPage(
                                            timeslots: ts.first,
                                          )));
                                          return;
                                        },
                                        leading: const Icon(Icons.schedule),
                                        title: const Text('Edit timeslots'),
                                      );
                                    }
                                  }()),
                                  _isSigningOut
                                      ? CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Color.fromARGB(255, 233, 64, 87)),
                                        )
                                      : ListTile(
                                          onTap: () {
                                            setState(() {
                                              _isSigningOut = true;
                                            });
                                            Authentication.signOutWithGoogle(
                                                context: context);
                                            setState(() {
                                              _isSigningOut = true;
                                            });
                                          },
                                          leading: const Icon(Icons.logout),
                                          title: const Text('Logout'),
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
          ),
        ),
        /*===BODY===*/
        Positioned(
          top: 220,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 320,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 0),
                child: SingleChildScrollView(child: BodyProfilePage())),
          ),
        ),
        /*===IMMAGINE DI PROFILO===*/
        Positioned(
          top: 150,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                    future:
                                        storage.downloadURL(us.profileImageURL),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            "Something went wrong!");
                                      } else if (snapshot.hasData) {
                                        return Image(
                                          image: NetworkImage(snapshot.data!),
                                        );
                                      } else {
                                        return const Card(
                                          margin: EdgeInsets.zero,
                                        );
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
                                showDragHandle: true,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                          onPressed: (() {
                                            _pickImage(ImageSource.gallery);
                                            return;
                                          }),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.collections_outlined),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('Browse Gallery'),
                                            ],
                                          )),
                                      const Text('or'),
                                      ElevatedButton(
                                          onPressed: (() {
                                            _pickImage(ImageSource.camera);
                                            return;
                                          }),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.camera_alt_outlined),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('Use a Camera'),
                                            ],
                                          )),
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
          ),
        ),
        /*===USER RATING E NUM. REVIEWS===*/
        Positioned(
          top: 150,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Text(
                              us.numRating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Text('reviews'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Text(
                              '${us.userRating}.0/5.0',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text('rating'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
