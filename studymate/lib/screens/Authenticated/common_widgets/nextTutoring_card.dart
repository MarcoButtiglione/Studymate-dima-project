import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/screens/Authenticated/common_widgets/card.dart';

import '../../../models/scheduled.dart';
import '../../../models/user.dart';

class NextTutoringCard extends StatefulWidget {
  final User user;

  const NextTutoringCard({super.key, required this.user});
  @override
  State<NextTutoringCard> createState() => _nextTutoringState();
}

class _nextTutoringState extends State<NextTutoringCard> {
  Stream<List<Scheduled>> readScheduled() => FirebaseFirestore.instance
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
        stream: readScheduled(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var schedule = snapshot.data!;
            if (schedule.isNotEmpty) {
              return Column(children: [
                const SizedBox(
                  height: 10,
                ),
                const Row(children: <Widget>[
                  Text("Your next tutoring",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                ]),
                const SizedBox(height: 10),
                StreamBuilder(
                    stream: readUser(schedule.first.studentId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var users = snapshot.data!;
                        return ClassCard(
                          tutorId: schedule.first.tutorId,
                          studentId: schedule.first.studentId,
                          id: schedule.first.id,
                          date: schedule.first.date,
                          title: schedule.first.title,
                          firstname: users.first.firstname,
                          lastname: users.first.lastname,
                          userImageURL: users.first.profileImageURL,
                          timeslot: schedule.first.timeslot,
                          tutor: true,
                          lessonPage: false,
                        );
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
