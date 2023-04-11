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

class NextLession extends StatefulWidget {
  @override
  _LessionState createState() => _LessionState();
}

class _LessionState extends State<NextLession> {
  final user = FirebaseAuth.instance.currentUser!;
  DateTime today = DateTime.now();
  List<String> categories = [];
  List<Scheduled> schedules = [];
  List<Users> users = [];
  List<DateTime> dates = [];
  String selectedLession = "";
  String selectedCategory = "";

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _scheduleRef =
      FirebaseFirestore.instance.collection('scheduled');
  final CollectionReference _lessonRef =
      FirebaseFirestore.instance.collection('lessons');

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    List<Scheduled> s = [];
    QuerySnapshot querySnapshot = await _scheduleRef
        .where("studentId", isEqualTo: user.uid)
        .where('accepted', isEqualTo: true)
        .where('date',
            isGreaterThan: Timestamp.fromDate(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)
                .subtract(const Duration(days: 1))))
        .orderBy('date', descending: true)
        .get();
    print(querySnapshot.docs.length);
    var allData = querySnapshot.docs.map((doc) {
      s.add(Scheduled(
          accepted: doc.get("accepted"),
          date: doc.get("date"),
          id: doc.get("id"),
          lessionId: doc.get("lessionId"),
          studentId: doc.get("studentId"),
          timeslot: doc.get("timeslot"),
          title: doc.get("title"),
          tutorId: doc.get("tutorId")));
    }).toList();
    List<Scheduled> sc = [];
    if (selectedLession != "") {
      s.forEach((element) {
        if (element.title == selectedLession) {
          sc.add(element);
        }
      });
    } else {
      sc = s;
    }

    List<Scheduled> schedul = [];
    if (selectedCategory == "" || selectedCategory == "Category") {
      schedul = sc;
    } else {
      QuerySnapshot querySnapshot1 =
          await _lessonRef.where("category", isEqualTo: selectedCategory).get();
      var allData1 = querySnapshot1.docs.map((doc) {
        sc.forEach((element) {
          if (element.lessionId == doc.get("id")) {
            schedul.add(element);
          }
        });
      }).toList();
    }
    List<DateTime> d = [];
    schedul.forEach((element) async {
      d.add(DateTime(element.date!.toDate().year, element.date!.toDate().month,
          element.date!.toDate().day));
      QuerySnapshot querySnapshot2 =
          await _userRef.where("id", isEqualTo: element.tutorId).get();
      print(querySnapshot2.docs.length);
      var allData2 = querySnapshot2.docs.map((doc) {
        print(doc.get("id"));
        users.add(Users(
            id: doc.get("id"),
            firstname: doc.get("firstname"),
            lastname: doc.get("lastname"),
            profileImageURL: doc.get("profileImage"),
            userRating: doc.get("userRating")));
      }).toList();
      print(users.length);
    });

    setState(() {
      schedules = schedul;
      dates = d;
    });
  }

  void callbackCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(dates);
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
                      AutocompleteSearchbar(onSelected: (selected) {
                        setState(() {
                          selectedLession = selected;
                          getData();
                        });
                      }),
                      const SizedBox(height: 10),
                      DropdownCategory(callbackCategory, onChanged: (selected) {
                        setState(() {
                          selectedCategory = selected;
                          getData();
                        });
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      TableCalendar(
                        locale: "en_US",
                        rowHeight: 40,
                        headerStyle: const HeaderStyle(
                            formatButtonVisible: false, titleCentered: true),
                        availableGestures: AvailableGestures.all,
                        eventLoader: (day) {
                          List<DateTime> events = [];
                          if (dates.contains(
                              DateTime(day.year, day.month, day.day))) {
                            events.add(day);
                          }
                          return events;
                        },
                        selectedDayPredicate: (day) => isSameDay(day, today),
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
                              print(today);
                              return (isSameDay(
                                      schedules[index].date!.toDate(), today))
                                  ? ClassCard(
                                      id: schedules[index].id,
                                      title: schedules[index].title,
                                      firstname: users[index].firstname,
                                      lastname: users[index].lastname,
                                      userImageURL:
                                          users[index].profileImageURL,
                                      date: schedules[index].date,
                                      timeslot: schedules[index].timeslot,
                                      tutor: false,
                                      lessonPage: true,
                                    )
                                  : SizedBox();
                            }),
                      ),
                    ]))));
  }
}
