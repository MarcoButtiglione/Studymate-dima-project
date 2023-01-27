import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studymate/screens/Authenticated/Search/widgets/autocomplete_searchbar.dart';
import 'package:studymate/screens/Authenticated/Search/widgets/category_card.dart';
import 'package:studymate/screens/Authenticated/Search/widgets/filter_bottomsheet_search.dart';
import 'package:studymate/screens/Authenticated/common_widgets/lesson_card.dart';
import 'package:studymate/screens/Authenticated/lesson_page.dart';
import 'package:substring_highlight/substring_highlight.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    builder: (context) => FilterBottomsheetSearch()
                  );
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
              child:
                  ListView(scrollDirection: Axis.horizontal, children: const [
                CategoryCard(
                  name: "Architecture",
                  url:
                      "https://images.unsplash.com/photo-1479839672679-a46483c0e7c8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=410&q=80",
                ),
                CategoryCard(
                  name: "Chemistry",
                  url:
                      "https://images.unsplash.com/photo-1554475900-0a0350e3fc7b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=417&q=80",
                ),
                CategoryCard(
                  name: "Computer science",
                  url:
                      "https://images.unsplash.com/photo-1610563166150-b34df4f3bcd6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1076&q=80",
                ),
                CategoryCard(
                  name: "Mathematics",
                  url:
                      "https://images.unsplash.com/photo-1635372722656-389f87a941b7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1331&q=80",
                ),
              ]),
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
            const SizedBox(height: 15),
            const LessonCard(
              lessonName: "Machine Learning",
              userName: "Robert Jackson",
              userImageURL: "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
              date: "Thursday 26/01/2023",
              location: "Milan",
            ),
            const SizedBox(height: 15),
            const LessonCard(
              lessonName: "Fisica tecnica",
              userName: "Mark Crosby",
              userImageURL: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
              date: "Thursday 26/01/2023",
              location: "Milan",
            ),
            const SizedBox(height: 15),
            const LessonCard(
              lessonName: "Analisi 1",
              userName: "Stephen King",
              userImageURL: "https://images.unsplash.com/photo-1581803118522-7b72a50f7e9f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
              date: "Thursday 26/01/2023",
              location: "Milan",
            ),
            const SizedBox(height: 15),
            const LessonCard(
              lessonName: "Teoria dei segnali",
              userName: "Mario Rossi",
              userImageURL: "https://images.unsplash.com/photo-1541752171745-4176eee47556?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
              date: "Thursday 26/01/2023",
              location: "Milan",
            ),
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