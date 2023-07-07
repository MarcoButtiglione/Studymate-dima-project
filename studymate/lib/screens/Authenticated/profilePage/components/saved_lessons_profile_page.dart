import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/models/savedLesson.dart';

import '../../../../models/lesson.dart';
import '../../../../service/storage_service.dart';
import '../../common_widgets/lesson_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SavedLessonsProfilePage extends StatefulWidget {
  @override
  State<SavedLessonsProfilePage> createState() =>
      _SavedLessonsProfilePageState();
}

class _SavedLessonsProfilePageState extends State<SavedLessonsProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final Storage storage = Storage();

  Stream<List<SavedLesson>> readSavedLessons(String userId) =>
      FirebaseFirestore.instance
          .collection('savedLessons')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => SavedLesson.fromFirestore(doc.data()))
              .toList());

  Stream<List<Lesson>> readLesson(String lessonId) => FirebaseFirestore.instance
      .collection('lessons')
      .where('id', isEqualTo: lessonId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SavedLesson>>(
        stream: readSavedLessons(user.uid),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong!");
          } else if (snapshot.hasData) {
            final savedLessons = snapshot.data!;
            if (savedLessons.isNotEmpty) {
              return Column(
                children: savedLessons
                    .map(
                      (salvedLesson) => StreamBuilder<List<Lesson>>(
                          stream: readLesson(salvedLesson.lessonId!),
                          builder: ((context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text("Something went wrong!");
                            } else if (snapshot.hasData) {
                              final lesson = snapshot.data!.first;
                              return LessonCard(
                                lesson: lesson,
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
              return Text(AppLocalizations.of(context)!.noLessonsSaved);
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }
}
