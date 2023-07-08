import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studymate/models/recordLessonViewed.dart';
import 'package:studymate/screens/Authenticated/Search/widgets/autocomplete_searchbar_searchpage.dart';
import 'package:studymate/screens/Authenticated/Search/widgets/category_card.dart';
import 'package:studymate/screens/Authenticated/common_widgets/lesson_card.dart';

import '../../../models/category.dart';
import '../../../models/lesson.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.search,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      AutocompleteSearchbarSearchPage(
                        lessonsTitle: lessonsTitle,
                        onSelectedCallback: ((p0) {
                          setState(() {
                            selectedLesson = p0;
                          });
                        }),
                        onCleanCallback: () {
                          setState(() {
                            selectedLesson = null;
                          });
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 10),
                        //Title category
                        Text(AppLocalizations.of(context)!.categories,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        //Category filter
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
                                                  selectedCategory =
                                                      category.name;
                                                });
                                                ;
                                              }
                                            }),
                                            child: CategoryCard(
                                              name: category.name,
                                              url: category.imageURL,
                                              selected: selectedCategory ==
                                                  category.name,
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
                        const SizedBox(height: 20),
                        (() {
                          //RECENT LESSONS
                          if (selectedCategory == null &&
                              selectedLesson == null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Recent
                                Text(AppLocalizations.of(context)!.recent,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                StreamBuilder<List<RecordLessonView>>(
                                    stream: readRecordLesson(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            "Something went wrong!");
                                      } else if (snapshot.hasData) {
                                        final recordLesson = snapshot.data!;
                                        //Controllo se ci sono due record con lo stesso lesson id e li rimuovo
                                        List<RecordLessonView> elementToRemove =
                                            [];
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
                                        if (recordLesson.length >= 1) {
                                          return StreamBuilder<List<Lesson>>(
                                              stream: readAllLessons(),
                                              builder: ((context, snapshot) {
                                                if (snapshot.hasError) {
                                                  return const Text(
                                                      "Something went wrong!");
                                                } else if (snapshot.hasData) {
                                                  List<Lesson> lessons =
                                                      snapshot.data!;

                                                  // Estrae solo gli ID dalla listaId
                                                  final listaIdString =
                                                      recordLesson
                                                          .map((oggetto) =>
                                                              oggetto.lessonId)
                                                          .toList();

                                                  // Filtra gli oggetti con ID presenti nella listaId
                                                  lessons.retainWhere(
                                                      (oggetto) => listaIdString
                                                          .contains(
                                                              oggetto.id));

                                                  // Ordina la lista degli oggetti in base all'ordine della listaId
                                                  lessons.sort((a, b) {
                                                    int indexA = listaIdString
                                                        .indexOf(a.id);
                                                    int indexB = listaIdString
                                                        .indexOf(b.id);
                                                    return indexA
                                                        .compareTo(indexB);
                                                  });

                                                  if (lessons.length >= 1) {
                                                    return GridView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                                        maxCrossAxisExtent: 400,
                                                        childAspectRatio:
                                                            35 / 9,
                                                        mainAxisSpacing: 10.0,
                                                        crossAxisSpacing: 10.0,
                                                      ),
                                                      itemCount: lessons.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return LessonCard(
                                                          lesson:
                                                              lessons[index],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                } else {
                                                  return const Center(
                                                      //child: CircularProgressIndicator(),
                                                      );
                                                }
                                              }));
                                        } else {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .noLessons),
                                              ),
                                            ],
                                          );
                                        }
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }))
                              ],
                            );
                          }
                          //CATEGORY SELECTED
                          else if (selectedCategory != null &&
                              selectedLesson == null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(selectedCategory!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                StreamBuilder<List<Lesson>>(
                                    stream: readLessonsByCategory(
                                        selectedCategory!),
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            "Something went wrong!");
                                      } else if (snapshot.hasData) {
                                        if (snapshot.data!.length >= 1) {
                                          final lessons = snapshot.data!;
                                          return GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 400,
                                              childAspectRatio: 35 / 9,
                                              mainAxisSpacing: 10.0,
                                              crossAxisSpacing: 10.0,
                                            ),
                                            itemCount: lessons.length,
                                            itemBuilder: (context, index) {
                                              return LessonCard(
                                                lesson: lessons[index],
                                              );
                                            },
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .noLessons),
                                              ),
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
                          }
                          //LESSON NAME SELECTED
                          else if (selectedCategory == null &&
                              selectedLesson != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(selectedLesson!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                StreamBuilder<List<Lesson>>(
                                    stream: readLessonsByTitle(selectedLesson!),
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            "Something went wrong!");
                                      } else if (snapshot.hasData) {
                                        if (snapshot.data!.length >= 1) {
                                          final lessons = snapshot.data!;
                                          return GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 400,
                                              childAspectRatio: 35 / 9,
                                              mainAxisSpacing: 10.0,
                                              crossAxisSpacing: 10.0,
                                            ),
                                            itemCount: lessons.length,
                                            itemBuilder: (context, index) {
                                              return LessonCard(
                                                lesson: lessons[index],
                                              );
                                            },
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .noLessons),
                                              ),
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
                          }
                          //LESSON NAME AND CATEGORY SELECTED
                          else if (selectedCategory != null &&
                              selectedLesson != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(selectedLesson!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                StreamBuilder<List<Lesson>>(
                                    stream: readLessonsByCategoryTitle(
                                        selectedCategory!, selectedLesson!),
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            "Something went wrong!");
                                      } else if (snapshot.hasData) {
                                        if (snapshot.data!.length >= 1) {
                                          final lessons = snapshot.data!;
                                          return GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 400,
                                              childAspectRatio: 35 / 9,
                                              mainAxisSpacing: 10.0,
                                              crossAxisSpacing: 10.0,
                                            ),
                                            itemCount: lessons.length,
                                            itemBuilder: (context, index) {
                                              return LessonCard(
                                                lesson: lessons[index],
                                              );
                                            },
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .noLessons),
                                              ),
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
                          }
                          return Container();
                        }()),
                      ],
                    ),
                  ),
                  //Categories
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
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
