import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/screens/Authenticated/common_widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../models/scheduled.dart';
import '../../../models/user.dart';

class HomeCard extends StatefulWidget {
  final User user;
  final bool isTutoring;
  const HomeCard({super.key, required this.user, required this.isTutoring});
  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  Stream<List<Scheduled>> readScheduledTutoring() => FirebaseFirestore.instance
      .collection('scheduled')
      .where('tutorId', isEqualTo: widget.user.uid)
      .where('accepted', isEqualTo: true)
      .where('date',
          isGreaterThan: Timestamp.fromDate(DateTime.utc(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(const Duration(days: 1))))
      .orderBy('date', descending: false)
      .limit(1)
      .snapshots()
      .map(((snapshot) => snapshot.docs
          .map((doc) => Scheduled.fromFirestore(doc.data()))
          .toList()));
  Stream<List<Scheduled>> readScheduledLesson() => FirebaseFirestore.instance
      .collection('scheduled')
      .where('studentId', isEqualTo: widget.user.uid)
      .where('accepted', isEqualTo: true)
      .where('date',
          isGreaterThan: Timestamp.fromDate(DateTime.utc(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(const Duration(days: 1))))
      .orderBy('date', descending: false)
      .limit(1)
      .snapshots()
      .map(((snapshot) => snapshot.docs
          .map((doc) => Scheduled.fromFirestore(doc.data()))
          .toList()));
  Stream<List<Users>> readUser(String? userId) => FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: StreamBuilder(
        stream:
            widget.isTutoring ? readScheduledTutoring() : readScheduledLesson(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var schedule = snapshot.data!;
            if (schedule.isNotEmpty) {
              return Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Row(children: <Widget>[
                  Text(
                      widget.isTutoring
                          ? AppLocalizations.of(context)!.nextTutoringTitle
                          : AppLocalizations.of(context)!.nextLessonTitle,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                ]),
                const SizedBox(height: 10),
                StreamBuilder(
                    stream: readUser(schedule.first.studentId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var students = snapshot.data!;
                        return StreamBuilder(
                            stream: readUser(schedule.first.tutorId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var tutors = snapshot.data!;
                                return ClassCard(
                                    tutor: tutors.first,
                                    student: students.first,
                                    id: schedule.first.id,
                                    date: schedule.first.date,
                                    title: schedule.first.title,
                                    timeslot: schedule.first.timeslot,
                                    isTutor: widget.isTutoring,
                                    lessonPage: false);
                              } else if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              } else {
                                return const SizedBox();
                              }
                            });
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return const SizedBox();
                      }
                    }),
                const SizedBox(height: 20),
                const Divider(
                  color: Colors.grey,
                ),
              ]);
            } else {
              return const SizedBox();
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
