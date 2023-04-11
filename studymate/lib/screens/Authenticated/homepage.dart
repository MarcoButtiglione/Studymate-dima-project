import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:studymate/functions/routingAnimation.dart';
import 'package:studymate/models/lesson.dart';
import 'package:studymate/models/user.dart';
import 'common_widgets/nextLession_card.dart';
import 'common_widgets/nextTutoring_card.dart';
import 'package:studymate/screens/Authenticated/Chat/chats_page.dart';
import 'package:studymate/screens/Authenticated/common_widgets/lesson_card.dart';
import 'package:studymate/screens/Authenticated/notification_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  Stream<List<Lesson>> readLessons(String userId, String category) =>
      FirebaseFirestore.instance
          .collection('lessons')
          .where('userTutor', isNotEqualTo: userId)
          .where('category', isEqualTo: category)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList());

  Stream<List<Users>> readUser(String userId) => FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            //Header
            Row(children: <Widget>[
              const Expanded(
                flex: 9,
                child: Text("Welcome",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              IconButton(
                icon: badges.Badge(
                  position: BadgePosition.topEnd(top: 0, end: 0),
                  showBadge: true,
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.grey,
                    size: 25.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(createRoute(const NotificationPage()));
                },
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: badges.Badge(
                  position: BadgePosition.topEnd(top: 0, end: 0),
                  showBadge: true,
                  child: const Icon(
                    Icons.message,
                    color: Colors.grey,
                    size: 25.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(createRoute(ChatsPage()));
                },
              ),
            ]),
            //--------------------
            //Your next lesson
            const SizedBox(height: 20),
            NextLessionCard(
              user: user,
            ),

            //--------------------
            //Your next tutoring

            NextTutoringCard(
              user: user,
            ),

            const SizedBox(height: 20),
            const Divider(
              color: Colors.grey,
            ),
            //--------------------
            //Suggested for you
            const SizedBox(height: 20),
            Row(children: const <Widget>[
              Text("Suggested for you",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 10),
            const Text(
                "This is a list of possible community tutors you could study with.",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 30),
            StreamBuilder<List<Users>>(
                stream: readUser(user.uid),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong!");
                  } else if (snapshot.hasData) {
                    final categories =
                        snapshot.data!.first.categoriesOfInterest;
                    return Column(
                      children: categories!
                          .map(
                            (category) => StreamBuilder<List<Lesson>>(
                                stream: readLessons(user.uid, category),
                                builder: ((context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text("Something went wrong!");
                                  } else if (snapshot.hasData) {
                                    final lessons = snapshot.data!;
                                    return Column(
                                      children: lessons
                                          .map(
                                            (lesson) => LessonCard(
                                              lesson: lesson,
                                            ),
                                          )
                                          .toList(),
                                    );
                                  } else {
                                    return const Center(
                                        //child: CircularProgressIndicator(),
                                        );
                                  }
                                })),
                          )
                          .toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }))

            //--------------------
          ],
        ),
      ),
    );
  }
}

class FilledCardExample extends StatelessWidget {
  const FilledCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          height: 300,
          child: Center(child: Text('Filled Card')),
        ),
      ),
    );
  }
}

class NextFilledCardExample extends StatelessWidget {
  const NextFilledCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          height: 100,
          child: Center(child: Text('Filled Card')),
        ),
      ),
    );
  }
}

class SmallFilledCardExample extends StatelessWidget {
  const SmallFilledCardExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          height: 70,
          width: 70,
        ),
      ),
    );
  }
}
