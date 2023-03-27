import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studymate/component/utils.dart';
import 'package:studymate/models/category.dart';
import 'package:studymate/models/chat.dart';
import 'package:studymate/screens/Authenticated/Chat/chats_page.dart';
import 'package:studymate/screens/Authenticated/other_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/lesson.dart';
import '../../models/user.dart';
import 'Chat/chat_msg.dart';

class LessonPage extends StatefulWidget {
  Lesson lesson;
  Users user;
  LessonPage({super.key, required this.lesson, required this.user});
  @override
  _LessonState createState() => _LessonState();
}

class _LessonState extends State<LessonPage> {
  final userFirebase = FirebaseAuth.instance.currentUser!;

  Stream<List<Category>> readCategory() => FirebaseFirestore.instance
      .collection('categories')
      .where('name', isEqualTo: widget.lesson.category)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  width: 150,
                  height: 600,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: StreamBuilder<List<Category>>(
                      stream: readCategory(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong!");
                        } else if (snapshot.hasData) {
                          final category = snapshot.data!.first;
                          return Image.network(
                            category.imageURL,
                            fit: BoxFit.fill,
                          );
                        } else {
                          return const Center(
                              //child: CircularProgressIndicator(),
                              );
                        }
                      })),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(context);
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
                            Icons.arrow_back_ios_new,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(_createRoute(const OtherProfilePage()));
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image(
                                image:
                                    NetworkImage(widget.user.profileImageURL),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.user.firstname + " " + widget.user.lastname,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 46, 46, 46),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 300,
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.lesson.title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.lesson.category,
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.lesson.description,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
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
                            children: [
                              Icon(
                                widget.user.userRating >= 1
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color.fromARGB(255, 101, 101, 101),
                              ),
                              Icon(
                                widget.user.userRating >= 2
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color.fromARGB(255, 101, 101, 101),
                              ),
                              Icon(
                                widget.user.userRating >= 3
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color.fromARGB(255, 101, 101, 101),
                              ),
                              Icon(
                                widget.user.userRating >= 4
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color.fromARGB(255, 101, 101, 101),
                              ),
                              Icon(
                                widget.user.userRating >= 5
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color.fromARGB(255, 101, 101, 101),
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
                top: 250,
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
                              Users receiver = widget.user;
                              send(receiver);
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
      List<String> users = [reciver.id, userFirebase.uid];
      List<Chat> chats = await readChat(users).first;
      Chat chat = Chat();
      if (chats.isEmpty) {
        final docChat = FirebaseFirestore.instance.collection('chat');
        List<String> member = [reciver.id, userFirebase.uid];
        await docChat.add({}).then((DocumentReference doc) {
          chat = Chat(member: member, num_msg: 0, last_msg: "", id: doc.id);
          final json = chat.toFirestore();
          docChat.doc(doc.id).update(json);
        });
      } else {
        chat = chats.first;
      }
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatMsg(
                    chat: chat,
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
