import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/lesson.dart';
import '../../../models/user.dart';
import '../../../service/storage_service.dart';
import '../Lesson/lesson_page.dart';

class LessonCard extends StatefulWidget {
  final Lesson lesson;

  const LessonCard({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  Users? user;

  Stream<List<Users>> readUser() => FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: widget.lesson.userTutor)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return Column(
      children: [
        const SizedBox(height: 15),
        StreamBuilder<List<Users>>(
          stream: readUser(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong!");
            } else if (snapshot.hasData) {
              final user = snapshot.data!.first;
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(_createRoute(LessonPage(
                    lesson: widget.lesson,
                    user: user,
                  )));
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: FutureBuilder(
                            future: storage.downloadURL(user.profileImageURL),
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
                            }),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.lesson.title,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(user.firstname + " " + user.lastname),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                user.userRating >= 1
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 13,
                                color: const Color.fromARGB(255, 101, 101, 101),
                              ),
                              Icon(
                                user.userRating >= 2
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 13,
                                color: const Color.fromARGB(255, 101, 101, 101),
                              ),
                              Icon(
                                user.userRating >= 3
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 13,
                                color: const Color.fromARGB(255, 101, 101, 101),
                              ),
                              Icon(
                                user.userRating >= 4
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 13,
                                color: const Color.fromARGB(255, 101, 101, 101),
                              ),
                              Icon(
                                user.userRating >= 5
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 13,
                                color: const Color.fromARGB(255, 101, 101, 101),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                  //child: CircularProgressIndicator(),
                  );
            }
          }),
        ),
      ],
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
