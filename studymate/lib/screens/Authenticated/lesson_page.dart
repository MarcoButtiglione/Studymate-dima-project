import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studymate/component/utils.dart';
import 'package:studymate/models/chat.dart';
import 'package:studymate/screens/Authenticated/Chat/chats_page.dart';
import 'package:studymate/screens/Authenticated/other_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user.dart';
import 'Chat/chat_msg.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key});
  @override
  _LessonState createState() => _LessonState();
}

class _LessonState extends State<LessonPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lesson"),
      ),
      body: Container(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: 150,
                height: 250,
                color: Theme.of(context).colorScheme.secondary,
                child: Image.network(
                  'https://images.unsplash.com/photo-1484417894907-623942c8ee29?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1332&q=80',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 30,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(_createRoute(const OtherProfilePage()));
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: const Image(
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Daniel Rogers",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(50.0),
                    topLeft: Radius.circular(50.0),
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Machine Learning",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Computer science",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Location",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Milano, MI",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              width: 100,
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.pin_drop,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("1 km")
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Date",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "26/01/2023, 16:00-17:00",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "About",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam suscipit dictum nunc ac euismod. Ut a tristique magna, eget lobortis enim.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "User rating",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 101, 101, 101),
                            ),
                            Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 101, 101, 101),
                            ),
                            Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 101, 101, 101),
                            ),
                            Icon(
                              Icons.star_border,
                              color: Color.fromARGB(255, 101, 101, 101),
                            ),
                            Icon(
                              Icons.star_border,
                              color: Color.fromARGB(255, 101, 101, 101),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, //Center Row contents horizontally,

                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: IconButton(
                          icon: const Icon(Icons.message_outlined),
                          onPressed: () {
                            Users reciver = Users(
                                firstname: "Dounia",
                                lastname: "Faouzi",
                                profileImageURL:
                                    'https://firebasestorage.googleapis.com/v0/b/my-firebase-3b25d.appspot.com/o/Categories%2FBiomedica.jpg?alt=media&token=3a9a75f4-654d-4c7f-8e75-d7acfac31d88',
                                id: 'qlM14qJEK5hdzszAIJ12H8q3z5L2',
                                userRating: 0);
                            send(reciver);
                          },
                          style: messageButtonStyle()),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(
                      width: 90,
                      height: 90,
                      child: SendRequestToggleButton(
                        isEnabled: true,
                        getDefaultStyle: sendRequestButtonStyle,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: SavedToggleButton(
                        isEnabled: true,
                        getDefaultStyle: savedButtonStyle,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Stream<List<Chat>> readChat(List<String> users) => FirebaseFirestore.instance
      .collection('chat')
      .where('member', isEqualTo: users)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Chat.fromFirestore(doc.data())).toList());

  Future send(Users reciver) async {
    try {
      List<String> users = [reciver.id, user.uid];
      List<Chat> chats = await readChat(users).first;
      print(chats.length);
      print("AAAAAAAAA");
      Chat chat;
      if (chats.isEmpty) {
        String docId = "";
        final docChat = FirebaseFirestore.instance.collection('chat');
        await docChat.add({}).then((DocumentReference doc) {
          docId = doc.id;
        });
        List<String> member = [reciver.id, user.uid];
        final addChat = Chat(member: member, id: docId, num_msg: 0);
        final json = addChat.toFirestore();
        await docChat.doc(docId).set(json);
        chat = addChat;
      } else {
        chat = chats.first;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatMsg(
                    num_msg: 0,
                    chatId: chat.id,
                    reciver: reciver,
                  )));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class SendRequestToggleButton extends StatefulWidget {
  const SendRequestToggleButton(
      {required this.isEnabled, this.getDefaultStyle, super.key});

  final bool isEnabled;
  final ButtonStyle? Function(bool, ColorScheme)? getDefaultStyle;

  @override
  State<SendRequestToggleButton> createState() =>
      _SendRequestToggleButtonState();
}

class _SendRequestToggleButtonState extends State<SendRequestToggleButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final VoidCallback? onPressed = widget.isEnabled
        ? () {
            setState(() {
              selected = !selected;
            });
          }
        : null;
    ButtonStyle? style;
    if (widget.getDefaultStyle != null) {
      style = widget.getDefaultStyle!(selected, colors);
    }

    return IconButton(
      isSelected: selected,
      icon: const Icon(
        Icons.check_outlined,
        size: 50,
      ),
      selectedIcon: const Icon(
        Icons.check,
        size: 50,
      ),
      onPressed: onPressed,
      style: style,
    );
  }
}

class SavedToggleButton extends StatefulWidget {
  const SavedToggleButton(
      {required this.isEnabled, this.getDefaultStyle, super.key});

  final bool isEnabled;
  final ButtonStyle? Function(bool, ColorScheme)? getDefaultStyle;

  @override
  State<SavedToggleButton> createState() => _SavedToggleButtonState();
}

class _SavedToggleButtonState extends State<SavedToggleButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final VoidCallback? onPressed = widget.isEnabled
        ? () {
            setState(() {
              selected = !selected;
            });
          }
        : null;
    ButtonStyle? style;
    if (widget.getDefaultStyle != null) {
      style = widget.getDefaultStyle!(selected, colors);
    }

    return IconButton(
      isSelected: selected,
      icon: const Icon(
        Icons.favorite_outline,
        size: 25,
      ),
      selectedIcon: const Icon(
        Icons.favorite,
        size: 25,
      ),
      onPressed: onPressed,
      style: style,
    );
  }
}

ButtonStyle sendRequestButtonStyle(bool selected, ColorScheme colors) {
  ColorScheme color =
      ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 215, 36));
  return IconButton.styleFrom(
    foregroundColor: selected ? color.onPrimary : color.primary,
    backgroundColor: selected ? color.primary : color.surfaceVariant,
    disabledForegroundColor: color.onSurface.withOpacity(0.38),
    disabledBackgroundColor: color.onSurface.withOpacity(0.12),
    hoverColor: selected
        ? color.onPrimary.withOpacity(0.08)
        : color.primary.withOpacity(0.08),
    focusColor: selected
        ? color.onPrimary.withOpacity(0.12)
        : color.primary.withOpacity(0.12),
    highlightColor: selected
        ? color.onPrimary.withOpacity(0.12)
        : color.primary.withOpacity(0.12),
  );
}

ButtonStyle savedButtonStyle(bool selected, ColorScheme colors) {
  ColorScheme color =
      ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 82, 14));
  return IconButton.styleFrom(
    foregroundColor: selected ? color.onPrimary : color.primary,
    backgroundColor: selected ? color.primary : color.surfaceVariant,
    disabledForegroundColor: color.onSurface.withOpacity(0.38),
    disabledBackgroundColor: color.onSurface.withOpacity(0.12),
    hoverColor: selected
        ? color.onPrimary.withOpacity(0.08)
        : color.primary.withOpacity(0.08),
    focusColor: selected
        ? color.onPrimary.withOpacity(0.12)
        : color.primary.withOpacity(0.12),
    highlightColor: selected
        ? color.onPrimary.withOpacity(0.12)
        : color.primary.withOpacity(0.12),
  );
}

ButtonStyle messageButtonStyle() {
  ColorScheme color =
      ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 168, 168, 168));
  return IconButton.styleFrom(
    foregroundColor: color.primary,
    backgroundColor: color.surfaceVariant,
    disabledForegroundColor: color.onSurface.withOpacity(0.38),
    disabledBackgroundColor: color.onSurface.withOpacity(0.12),
    hoverColor: color.primary.withOpacity(0.08),
    focusColor: color.primary.withOpacity(0.12),
    highlightColor: color.primary.withOpacity(0.12),
  );
}
