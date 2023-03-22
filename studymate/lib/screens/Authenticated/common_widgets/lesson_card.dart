import 'package:flutter/material.dart';

import '../lesson_page.dart';

class LessonCard extends StatelessWidget {
  final String lessonName;
  final String userName;
  final String userImageURL;
  final String date;
  final String location;
  const LessonCard({
    super.key,
    required this.lessonName,
    required this.userName,
    required this.userImageURL,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        InkWell(
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
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(userImageURL),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          lessonName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(userName),
                      ],
                    ),
                    Row(
                      children: [
                        Text("$date, $location"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
