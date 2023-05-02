import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studymate/models/recordLessonViewed.dart';
import 'package:studymate/screens/Authenticated/Search/widgets/autocomplete_searchbar.dart';
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
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());

  Stream<List<Lesson>> readLessons(String lessonId) =>
      FirebaseFirestore.instance
          .collection('lessons')
          .where('id', isEqualTo: lessonId)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(children: <Widget>[
              const Expanded(
                flex: 9,
                child: Text("Search",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              IconButton(
                icon: const Icon(
                  Icons.tune,
                  color: Colors.grey,
                  size: 25.0,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) => FilterBottomsheetSearch());
                },
              ),
            ]),
            AutocompleteSearchbar(),
            const SizedBox(height: 10),
            //Categories
            Row(children: const <Widget>[
              Text("Categories",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                          .map((category) => CategoryCard(
                              name: category.name, url: category.imageURL))
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
            const SizedBox(height: 20),
            //Recent
            Row(children: const <Widget>[
              Text("Recent",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                    List<RecordLessonView> elementToRemove=[];
                    int index=0;
                    for (var element in recordLesson) {
                      int i=0;
                      bool toRemove=false;
                      while(i<index&&!toRemove){
                        if(recordLesson.elementAt(i).lessonId==element.lessonId){
                          toRemove=true;
                        }
                        i++;
                      }
                      if(toRemove){
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
                            (record) => StreamBuilder<List<Lesson>>(
                                stream: readLessons(record.lessonId!),
                                builder: ((context, snapshot) {
                                  

                                  if (snapshot.hasError) {
                                    return const Text("Something went wrong!");
                                  } else if (snapshot.hasData) {
                                    if (snapshot.data!.length >= 1) {
                                      
                                      final lesson = snapshot.data!.first;
                                      return LessonCard(
                                        lesson: lesson,
                                      );
                                    }
                                    else{
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
        ),
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
