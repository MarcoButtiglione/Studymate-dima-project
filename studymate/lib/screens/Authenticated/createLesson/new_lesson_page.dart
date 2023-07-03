import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:studymate/models/lesson.dart';
import 'package:studymate/screens/Authenticated/hoursselection_page.dart';

import '../../../component/utils.dart';
import '../../../functions/routingAnimation.dart';
import '../../../models/category.dart';
import 'components/dropdownCategory.dart';

Stream<List<Category>> readCategory() => FirebaseFirestore.instance
    .collection('categories')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());

class NewLessonPage extends StatefulWidget {
  @override
  State<NewLessonPage> createState() => _NewLessonPageState();
}

class _NewLessonPageState extends State<NewLessonPage> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  bool isBusy = false;

  final titleController = TextEditingController();
  String category = "";
  String date = "";
  String startingTime = "";
  int duration = 1;
  final desciptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    desciptionController.dispose();
    super.dispose();
  }

  void callbackCategory(String category) {
    setState(() {
      this.category = category;
    });
  }

  void callbackDate(String date) {
    setState(() {
      this.date = date;
    });
  }

  void callbackDuration(int duration) {
    setState(() {
      this.duration = duration;
    });
  }

  Future send({required Lesson lesson}) async {
    try {
      setState(() {
        isBusy = true;
      });

      String docId = "";
      final docLesson = FirebaseFirestore.instance.collection('lessons');
      final json = lesson.toFirestore();
      await docLesson.add(json).then((DocumentReference doc) {
        docId = doc.id;
      });

      await docLesson.doc(docId).update({'id': docId});
      setState(() {
        isBusy = false;
        duration = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson added!')),
      );
      titleController.clear();
      desciptionController.clear();
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isBusy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: StreamBuilder<List<Category>>(
                    stream: readCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong!");
                      } else if (snapshot.hasData) {
                        final categories = snapshot.data!;
                        return Column(
                          children: [
                            const SizedBox(height: 60),
                            Row(children: const <Widget>[
                              Text("Create a lesson",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ]),
                            const Text(
                                "Here you can create your lesson. Give lessons to other people in the community to receive points that you can spend on other community lessons.",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 13)),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: titleController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: "Title",
                                hintText: "Type the title of your lesson",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownCategory(callback: callbackCategory,categories: categories, initCategory: ""),
                            const SizedBox(height: 10),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: desciptionController,
                              keyboardType: TextInputType.multiline,
                              minLines: 7,
                              maxLines: 7,
                              decoration: InputDecoration(
                                //labelText: "Description",
                                hintText: "Type the description of your lesson",

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 233, 64, 87),
                                    ),
                                    onPressed: () {
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (_formKey.currentState!.validate()) {
                                        FirebaseFirestore.instance
                                            .collection('timeslots')
                                            .where('userId',
                                                isEqualTo: user.uid)
                                            .get()
                                            .then((querySnapshot) {
                                          if (querySnapshot.docs.isNotEmpty) {
                                            // Do something if the document exists
                                            final lesson = Lesson(
                                              title: titleController.text,
                                              location: "Milan",
                                              description:
                                                  desciptionController.text,
                                              userTutor: user.uid,
                                              category: category,
                                            );
                                            send(lesson: lesson);
                                          } else {
                                            // Do something if the document does not exist
                                            Navigator.of(context).push(
                                                createRoute(
                                                    const HoursSelectionPage()));
                                          }
                                        });
                                      } else {
                                        //Navigator.of(context).push(createRoute(
                                        //  const HoursSelectionPage()));
                                      }
                                    },
                                    child: const Text('Submit',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
      ),
    );
  }
}
