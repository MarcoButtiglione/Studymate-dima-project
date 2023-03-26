import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:studymate/functions/routingAnimation.dart';
import 'package:studymate/models/category.dart';
import 'package:studymate/models/lesson.dart';
import 'package:studymate/models/user.dart';

import 'package:studymate/screens/Authenticated/Chat/chats_page.dart';
import 'package:studymate/screens/Authenticated/common_widgets/lesson_card.dart';
import 'package:studymate/screens/Authenticated/lesson_page.dart';
import 'package:studymate/screens/Authenticated/notification_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  Stream<List<Lesson>> readLessons(String userId,String category) => FirebaseFirestore.instance
      .collection('lessons')
      .where('userTutor', isNotEqualTo: userId)
      .where('category',isEqualTo: category)

      //.orderBy('addtime', descending: true)
      //.limit(10)
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
            Row(children: const <Widget>[
              Text("Your next lesson",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
            Row(
              children: <Widget>[
                const Expanded(
                  flex: 9,
                  child: NextFilledCardExample(),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("1"),
                            SizedBox(width: 10),
                            Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("1"),
                            SizedBox(width: 10),
                            Icon(
                              Icons.star,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.mode,
                                color: Colors.grey,
                                size: 25.0,
                              ),
                              onPressed: () {
                                //
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.grey,
            ),
            //--------------------
            //Your next tutoring
            const SizedBox(height: 20),
            Row(children: const <Widget>[
              Text("Your next tutoring",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
            Row(
              children: <Widget>[
                const Expanded(
                  flex: 9,
                  child: NextFilledCardExample(),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("1"),
                            SizedBox(width: 10),
                            Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("1"),
                            SizedBox(width: 10),
                            Icon(
                              Icons.star,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.mode,
                                color: Colors.grey,
                                size: 25.0,
                              ),
                              onPressed: () {
                                //
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
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
                                stream: readLessons(user.uid,category),
                                builder: ((context, snapshot) {
                                  if (snapshot.hasError) {
                                    
                                    return const Text("Something went wrong!");
                                  } else if (snapshot.hasData) {
                                    final lessons = snapshot.data!;
                                    return Column(
                                      children: lessons
                                          .map(
                                            (lesson) => LessonCard(
                                              lessonName: lesson.title,
                                              userName: lesson.userTutor,
                                              userImageURL:
                                                  "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
                                              date: "Thursday 26/01/2023",
                                              location: lesson.location,
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

class SuggestedItem extends StatelessWidget {
  const SuggestedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(createRoute(const LessonPage()));
      },
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: const Image(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80'),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      "Machine Learning",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text("Thursday 26/01/2023, Milan"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
