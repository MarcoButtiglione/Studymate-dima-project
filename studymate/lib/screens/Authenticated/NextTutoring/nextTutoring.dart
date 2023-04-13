import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/screens/Authenticated/NextLesson/DropDownList.dart';
import 'package:studymate/screens/Authenticated/NextLesson/autocomplete_searchbar.dart';
import 'package:studymate/screens/Authenticated/common_widgets/card.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/category.dart';
import '../../../models/lesson.dart';
import '../../../models/scheduled.dart';
import '../../../models/user.dart';

class NextTutoring extends StatefulWidget {
  @override
  _TutoringState createState() => _TutoringState();
}

class _TutoringState extends State<NextTutoring> {
  final user = FirebaseAuth.instance.currentUser!;
  DateTime today = DateTime.now();
  List<Users> users = [];
  String selectedLession = "";
  String selectedCategory = "";

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> getUser(Scheduled element) async {
    List<Users> usrs = [];
    var userId = "";
    if (element.studentId == user.uid) {
      userId = element.tutorId.toString();
    } else {
      userId = element.studentId.toString();
    }
    QuerySnapshot querySnapshot2 =
        await _userRef.where("id", isEqualTo: userId).get();
    var allData2 = querySnapshot2.docs.map((doc) {
      usrs.add(Users(
        id: doc.get("id"),
        firstname: doc.get("firstname"),
        lastname: doc.get("lastname"),
        profileImageURL: doc.get("profileImage"),
        userRating: doc.get("userRating"),
        hours: doc.get("hours"),
        numRating: doc.get("numRating"),
      ));
    }).toList();
    users = usrs;
  }

  void callbackCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Stream<List<Scheduled>> readScheduled() => FirebaseFirestore.instance
      .collection('scheduled')
      .where('tutorId', isEqualTo: user.uid)
      .where('accepted', isEqualTo: true)
      .where('date',
          isGreaterThan: Timestamp.fromDate(DateTime.utc(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .subtract(const Duration(days: 1))))
      .orderBy('date', descending: true)
      .snapshots()
      .map(((snapshot) => snapshot.docs
          .map((doc) => Scheduled.fromFirestore(doc.data()))
          .toList()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Row(children: <Widget>[
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            )),
                        const Expanded(
                            child: Text("Tutoring",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ]),
                      const SizedBox(height: 10),
                      AutocompleteSearchbar(onSelected: (selected) {
                        setState(() {
                          selectedLession = selected;
                          // getData();
                        });
                      }),
                      const SizedBox(height: 10),
                      DropdownCategory(callbackCategory, onChanged: (selected) {
                        setState(() {
                          selectedCategory = selected;
                          //getData();
                        });
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                          stream: readScheduled(),
                          builder: (context, snapshot) {
                            List<Scheduled> schedules = [];
                            List<DateTime> dates = [];
                            if (snapshot.hasData) {
                              schedules = snapshot.data!;
                              if (schedules.isNotEmpty) {
                                if (selectedCategory == "" ||
                                    selectedCategory == "Category") {
                                  if (selectedLession != "") {
                                    schedules.removeWhere((element) =>
                                        element.title != selectedLession);
                                  }
                                } else {
                                  if (selectedLession != "") {
                                    schedules.removeWhere((element) =>
                                        (element.category != selectedCategory ||
                                            element.title != selectedLession));
                                  } else {
                                    schedules.removeWhere((element) =>
                                        element.category != selectedCategory);
                                  }
                                }
                                schedules.forEach((element) {
                                  dates.add(DateTime(
                                      element.date!.toDate().year,
                                      element.date!.toDate().month,
                                      element.date!.toDate().day));
                                });
                              }
                            }
                            return Column(
                              children: [
                                TableCalendar(
                                  locale: "en_US",
                                  rowHeight: 40,
                                  headerStyle: const HeaderStyle(
                                      formatButtonVisible: false,
                                      titleCentered: true),
                                  availableGestures: AvailableGestures.all,
                                  eventLoader: (day) {
                                    List<DateTime> events = [];
                                    if (dates.contains(DateTime(
                                        day.year, day.month, day.day))) {
                                      events.add(day);
                                    }
                                    return events;
                                  },
                                  selectedDayPredicate: (day) =>
                                      isSameDay(day, today),
                                  focusedDay: today,
                                  firstDay: DateTime.now(),
                                  lastDay: DateTime.utc(2025, 12, 31),
                                  onDaySelected: _onDaySelected,
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: schedules.length,
                                      itemBuilder: (context, index) {
                                        getUser(schedules[index]);

                                        return (isSameDay(
                                                schedules[index].date!.toDate(),
                                                today))
                                            ? ClassCard(
                                                tutorId:
                                                    schedules[index].tutorId,
                                                studentId:
                                                    schedules[index].studentId,
                                                id: schedules[index].id,
                                                title: schedules[index].title,
                                                firstname: users[0].firstname,
                                                lastname: users[0].lastname,
                                                userImageURL:
                                                    users[0].profileImageURL,
                                                date: schedules[index].date,
                                                timeslot:
                                                    schedules[index].timeslot,
                                                tutor: true,
                                                lessonPage: true,
                                              )
                                            : SizedBox();
                                      }),
                                ),
                              ],
                            );
                          })
                    ]))));
  }
}
