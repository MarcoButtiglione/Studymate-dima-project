import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:studymate/screens/Authenticated/Chat/chat_page.dart';
import 'package:studymate/screens/Authenticated/common_widgets/lesson_card.dart';
import 'package:studymate/screens/Authenticated/lesson_page.dart';
import 'package:studymate/screens/Authenticated/notification_page.dart';

class HomePage extends StatelessWidget {
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
                      .push(_createRoute(const NotificationPage()));
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
                  Navigator.of(context).push(_createRoute(ChatPage()));
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
            const SizedBox(height: 15),
            const LessonCard(
              lessonName: "Machine Learning",
              userName: "Robert Jackson",
              userImageURL:
                  "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
              date: "Thursday 26/01/2023",
              location: "Milan",
            ),
            const SizedBox(height: 15),
            const LessonCard(
              lessonName: "Fisica tecnica",
              userName: "Mark Crosby",
              userImageURL:
                  "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
              date: "Thursday 26/01/2023",
              location: "Milan",
            ),
            const SizedBox(height: 15),
            const LessonCard(
              lessonName: "Analisi 1",
              userName: "Stephen King",
              userImageURL:
                  "https://images.unsplash.com/photo-1581803118522-7b72a50f7e9f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
              date: "Thursday 26/01/2023",
              location: "Milan",
            ),
            const SizedBox(height: 15),
            const LessonCard(
              lessonName: "Teoria dei segnali",
              userName: "Mario Rossi",
              userImageURL:
                  "https://images.unsplash.com/photo-1541752171745-4176eee47556?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
              date: "Thursday 26/01/2023",
              location: "Milan",
            ),

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
        Navigator.of(context).push(_createRoute(const LessonPage()));
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
