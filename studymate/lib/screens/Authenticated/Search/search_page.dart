import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studymate/models/recordLessonViewed.dart';
import 'package:studymate/screens/Authenticated/Search/widgets/autocomplete_searchbar_searchpage.dart';
import 'package:studymate/screens/Authenticated/Search/widgets/category_card.dart';
import 'package:studymate/screens/Authenticated/Search/widgets/filter_bottomsheet_search.dart';
import 'package:studymate/screens/Authenticated/common_widgets/lesson_card.dart';
import 'package:studymate/screens/Authenticated/Lesson/lesson_page.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../models/category.dart';
import '../../../models/lesson.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userLog = FirebaseAuth.instance.currentUser!;
  String? selectedCategory;
  String? selectedLesson;

  Stream<List<RecordLessonView>> readRecordLesson() =>
      FirebaseFirestore.instance
          .collection('recordLessonsViewed')
          .where('userId', isEqualTo: userLog.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => RecordLessonView.fromFirestore(doc.data()))
              .toList());

  Stream<List<Category>> readCategory() => FirebaseFirestore.instance
      .collection('categories')
      .orderBy('name')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());

  Stream<List<Lesson>> readAllLessons() => FirebaseFirestore.instance
      .collection('lessons')
      .where('userTutor', isNotEqualTo: userLog.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList());

  Stream<List<Lesson>> readLessonsById(String lessonId) =>
      FirebaseFirestore.instance
          .collection('lessons')
          .where('id', isEqualTo: lessonId)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList());

  Stream<List<Lesson>> readLessonsByCategory(String category) =>
      FirebaseFirestore.instance
          .collection('lessons')
          .where('userTutor', isNotEqualTo: userLog.uid)
          .where('category', isEqualTo: category)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList());

  Stream<List<Lesson>> readLessonsByTitle(String title) =>
      FirebaseFirestore.instance
          .collection('lessons')
          .where('userTutor', isNotEqualTo: userLog.uid)
          .where('title', isEqualTo: title)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList());

  Stream<List<Lesson>> readLessonsByCategoryTitle(
          String category, String title) =>
      FirebaseFirestore.instance
          .collection('lessons')
          .where('userTutor', isNotEqualTo: userLog.uid)
          .where('category', isEqualTo: category)
          .where('title', isEqualTo: title)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Lesson>>(
            stream: selectedCategory == null
                ? readAllLessons()
                : readLessonsByCategory(selectedCategory!),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong!");
              } else if (snapshot.hasData) {
                var lessons = snapshot.data!;
                List<String> lessonsTitle = [];
                for (var element in lessons) {
                  lessonsTitle.add(element.title);
                }
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Search",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    AutocompleteSearchbarSearchPage(
                      lessonsTitle: lessonsTitle,
                      onSelectedCallback: ((p0) {
                        setState(() {
                          selectedLesson = p0;
                        });
                      }),
                      onCleanCallback: () {
                        setState(() {
                          selectedLesson=null;
                        });
                      },
                    ),
                    //Categories
                    Row(children: const <Widget>[
                      Text("Categories",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ]),

                    SizedBox(
                      height: 180.0,
                      child: StreamBuilder<List<Category>>(
                        stream: readCategory(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Something went wrong!");
                          } else if (snapshot.hasData) {
                            final categories = snapshot.data!;
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: categories
                                  .map((category) => InkWell(
                                        onTap: (() {
                                          if (selectedCategory ==
                                              category.name) {
                                            setState(() {
                                              selectedCategory = null;
                                            });
                                          } else {
                                            setState(() {
                                              selectedCategory = category.name;
                                            });
                                            ;
                                          }
                                        }),
                                        child: CategoryCard(
                                          name: category.name,
                                          url: category.imageURL,
                                          selected:
                                              selectedCategory == category.name,
                                        ),
                                      ))
                                  .toList(),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    (() {
                      if (selectedCategory == null && selectedLesson == null) {
                        return Column(
                          children: [
                            //Recent
                            Row(children: const <Widget>[
                              Text("Recent",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ]),
                            const SizedBox(height: 10),
                            StreamBuilder<List<RecordLessonView>>(
                                stream: readRecordLesson(),
                                builder: ((context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text("Something went wrong!");
                                  } else if (snapshot.hasData) {
                                    final recordLesson = snapshot.data!;
                                    //Controllo se ci sono due record con lo stesso lesson id e li rimuovo
                                    List<RecordLessonView> elementToRemove = [];
                                    int index = 0;
                                    for (var element in recordLesson) {
                                      int i = 0;
                                      bool toRemove = false;
                                      while (i < index && !toRemove) {
                                        if (recordLesson
                                                .elementAt(i)
                                                .lessonId ==
                                            element.lessonId) {
                                          toRemove = true;
                                        }
                                        i++;
                                      }
                                      if (toRemove) {
                                        elementToRemove.add(element);
                                      }
                                      index++;
                                    }
                                    for (var element in elementToRemove) {
                                      recordLesson.remove(element);
                                    }
                                    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                    return Column(
                                      children: recordLesson
                                          .map(
                                            (record) => StreamBuilder<
                                                    List<Lesson>>(
                                                stream: readLessonsById(
                                                    record.lessonId!),
                                                builder: ((context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return const Text(
                                                        "Something went wrong!");
                                                  } else if (snapshot.hasData) {
                                                    if (snapshot.data!.length >=
                                                        1) {
                                                      final lesson =
                                                          snapshot.data!.first;
                                                      return LessonCard(
                                                        lesson: lesson,
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
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
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }))
                          ],
                        );
                      } else if (selectedCategory != null &&
                          selectedLesson == null) {
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(selectedCategory!,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            StreamBuilder<List<Lesson>>(
                                stream:
                                    readLessonsByCategory(selectedCategory!),
                                builder: ((context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text("Something went wrong!");
                                  } else if (snapshot.hasData) {
                                    if (snapshot.data!.length >= 1) {
                                      final lesson = snapshot.data!.first;
                                      return LessonCard(
                                        lesson: lesson,
                                      );
                                    } else {
                                      return Column(
                                        children: const [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text('No lessons here.'),
                                        ],
                                      );
                                    }
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })),
                          ],
                        );
                      } else if (selectedCategory == null &&
                          selectedLesson != null) {
                        return Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(selectedLesson!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                          StreamBuilder<List<Lesson>>(
                              stream: readLessonsByTitle(selectedLesson!),
                              builder: ((context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Something went wrong!");
                                } else if (snapshot.hasData) {
                                  if (snapshot.data!.length >= 1) {
                                    final lesson = snapshot.data!.first;
                                    return LessonCard(
                                      lesson: lesson,
                                    );
                                  } else {
                                    return Column(
                                      children: const [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text('No lessons here.'),
                                      ],
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              })),
                        ]);
                      } else if (selectedCategory != null &&
                          selectedLesson != null) {
                        return Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(selectedLesson!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                          StreamBuilder<List<Lesson>>(
                              stream: readLessonsByCategoryTitle(
                                  selectedCategory!, selectedLesson!),
                              builder: ((context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Something went wrong!");
                                } else if (snapshot.hasData) {
                                  if (snapshot.data!.length >= 1) {
                                    final lesson = snapshot.data!.first;
                                    return LessonCard(
                                      lesson: lesson,
                                    );
                                  } else {
                                    return Column(
                                      children: const [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text('No lessons here.'),
                                      ],
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              })),
                        ]);
                      }
                      return Container();
                    }()),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
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
