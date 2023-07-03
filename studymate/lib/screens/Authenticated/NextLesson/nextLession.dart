
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/screens/Authenticated/NextLesson/DropDownList.dart';
import 'package:studymate/screens/Authenticated/NextLesson/autocomplete_searchbar.dart';
import 'package:studymate/screens/Authenticated/common_widgets/card.dart';
import 'package:table_calendar/table_calendar.dart';


import '../../../models/scheduled.dart';
import '../../../models/user.dart';

class NextLession extends StatefulWidget {
  @override
  _LessionState createState() => _LessionState();
}

class _LessionState extends State<NextLession> {
  final user = FirebaseAuth.instance.currentUser!;
  DateTime today = DateTime.now();
  String selectedLession = "";
  String selectedCategory = "";

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  void callbackCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Stream<List<Users>> readUser(String? id) => FirebaseFirestore.instance
      .collection("users")
      .where("id", isEqualTo: id)
      .snapshots()
      .map(((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList()));
  Stream<List<Scheduled>> readScheduled() => FirebaseFirestore.instance
      .collection('scheduled')
      .where('studentId', isEqualTo: user.uid)
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
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.width;
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
                            child: Text("Lessons",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ]),
                      const SizedBox(height: 10),
                      w > 720
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: (w > 720) ? w * 0.4 : w * 0.8,
                                  child: AutocompleteSearchbar(
                                      onSelected: (selected) {
                                    setState(() {
                                      selectedLession = selected;
                                      // getData();
                                    });
                                  }),
                                ),
                                SizedBox(
                                  width: (w > 720) ? w * 0.4 : w * 0.8,
                                  child: DropdownCategory(callbackCategory,
                                      onChanged: (selected) {
                                    setState(() {
                                      selectedCategory = selected;
                                      //getData();
                                    });
                                  }),
                                ),
                              ],
                            )
                          : Column(children: [
                              SizedBox(
                                width: (w > 720) ? w * 0.4 : w * 0.8,
                                child: AutocompleteSearchbar(
                                    onSelected: (selected) {
                                  setState(() {
                                    selectedLession = selected;
                                    // getData();
                                  });
                                }),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: (w > 720) ? w * 0.4 : w * 0.8,
                                child: DropdownCategory(callbackCategory,
                                    onChanged: (selected) {
                                  setState(() {
                                    selectedCategory = selected;
                                    //getData();
                                  });
                                }),
                              ),
                            ]),
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
                            if (w > 1000) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: w * 0.45,
                                    child: TableCalendar(
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
                                  ),
                                  SizedBox(
                                    width: w * 0.45,
                                    height: h,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: schedules.length,
                                        itemBuilder: (context, index) {
                                          return FutureBuilder(
                                              future: readUser(schedules[index]
                                                      .studentId)
                                                  .first,
                                              builder: ((context, snapshot) {
                                                if (snapshot.hasData) {
                                                  var users = snapshot.data!;
                                                  if (users.isNotEmpty) {
                                                    return (isSameDay(
                                                            schedules[index]
                                                                .date!
                                                                .toDate(),
                                                            today))
                                                        ? ClassCard(
                                                            tutorId:
                                                                schedules[index]
                                                                    .tutorId,
                                                            studentId:
                                                                schedules[index]
                                                                    .studentId,
                                                            id: schedules[index]
                                                                .id,
                                                            title:
                                                                schedules[index]
                                                                    .title,
                                                            firstname: users
                                                                .first
                                                                .firstname,
                                                            lastname: users
                                                                .first.lastname,
                                                            userImageURL: users
                                                                .first
                                                                .profileImageURL,
                                                            date:
                                                                schedules[index]
                                                                    .date,
                                                            timeslot:
                                                                schedules[index]
                                                                    .timeslot,
                                                            tutor: false,
                                                            lessonPage: true,
                                                          )
                                                        : SizedBox();
                                                  }
                                                }
                                                return SizedBox();
                                              }));
                                        }),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: w * 0.9,
                                    child: TableCalendar(
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
                                  ),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                        scrollDirection: h > 720
                                            ? Axis.vertical
                                            : Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: schedules.length,
                                        itemBuilder: (context, index) {
                                          return FutureBuilder(
                                              future: readUser(schedules[index]
                                                      .studentId)
                                                  .first,
                                              builder: ((context, snapshot) {
                                                if (snapshot.hasData) {
                                                  var users = snapshot.data!;
                                                  if (users.isNotEmpty) {
                                                    return (isSameDay(
                                                            schedules[index]
                                                                .date!
                                                                .toDate(),
                                                            today))
                                                        ? ClassCard(
                                                            tutorId:
                                                                schedules[index]
                                                                    .tutorId,
                                                            studentId:
                                                                schedules[index]
                                                                    .studentId,
                                                            id: schedules[index]
                                                                .id,
                                                            title:
                                                                schedules[index]
                                                                    .title,
                                                            firstname: users
                                                                .first
                                                                .firstname,
                                                            lastname: users
                                                                .first.lastname,
                                                            userImageURL: users
                                                                .first
                                                                .profileImageURL,
                                                            date:
                                                                schedules[index]
                                                                    .date,
                                                            timeslot:
                                                                schedules[index]
                                                                    .timeslot,
                                                            tutor: false,
                                                            lessonPage: true,
                                                          )
                                                        : SizedBox();
                                                  }
                                                }
                                                return SizedBox();
                                              }));
                                        }),
                                  ),
                                ],
                              );
                            }
                          })
                    ]))));
  }
}
