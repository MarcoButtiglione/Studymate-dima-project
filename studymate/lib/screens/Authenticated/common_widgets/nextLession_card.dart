import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/scheduled.dart';
import '../../../models/user.dart';

class NextLessionCard extends StatefulWidget {
  final User user;

  const NextLessionCard({super.key, required this.user});
  @override
  State<NextLessionCard> createState() => _nextLessionState();
}

class _nextLessionState extends State<NextLessionCard> {
  Stream<List<Scheduled>> readScheduled() => FirebaseFirestore.instance
      .collection('scheduled')
      .where('studentId', isEqualTo: widget.user.uid)
      .where('accepted', isEqualTo: true)
      .where('date',
          isGreaterThan: Timestamp.fromDate(DateTime.utc(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(const Duration(days: 1))))
      .orderBy('date', descending: true)
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
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: FutureBuilder(
        future: readScheduled().first,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var schedule = snapshot.data!;
            if (schedule.isNotEmpty) {
              return Column(children: [
                Row(children: const <Widget>[
                  Text("Your next lession",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                ]),
                SizedBox(height: 10),
                FutureBuilder(
                    future: readUser(schedule.first.tutorId).first,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var users = snapshot.data!;
                        return Container(
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(children: [
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Image(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          users.first.profileImageURL),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                    child: Column(children: [
                                  Row(
                                    children: [
                                      Text(
                                        schedule.first.title,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 233, 64, 87),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Tutor:  ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Text(
                                            "${users.first.firstname} ${users.first.lastname}"),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Date:   ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Text(DateFormat.yMd().format(
                                            schedule.first.date!.toDate())),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 2.5,
                                        ),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount:
                                            schedule.first.timeslot!.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 233, 64, 87),
                                                    width: 1)),
                                            child: Center(
                                              child: Text(
                                                schedule.first.timeslot![index],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ]))
                              ]),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "see next...",
                                      textAlign: TextAlign.right,
                                    )),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return SizedBox();
                      }
                    })
              ]);
            } else {
              return SizedBox();
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
