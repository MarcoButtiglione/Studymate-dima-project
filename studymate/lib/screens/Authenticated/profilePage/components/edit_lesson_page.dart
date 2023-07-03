import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:studymate/models/lesson.dart';
import 'package:studymate/screens/Authenticated/hoursselection_page.dart';

import '../../../../component/utils.dart';
import '../../../../functions/routingAnimation.dart';
import '../../../../models/category.dart';
import '../../createLesson/components/dropdownCategory.dart';

Stream<List<Category>> readCategory() => FirebaseFirestore.instance
    .collection('categories')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());

class EditLessonPage extends StatefulWidget {
  final Lesson lesson;
  const EditLessonPage({super.key, required this.lesson});
  @override
  State<EditLessonPage> createState() => _EditLessonPageState();
}

class _EditLessonPageState extends State<EditLessonPage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      titleController.text = widget.lesson.title;
      category = widget.lesson.category;
      desciptionController.text = widget.lesson.description;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  bool isBusy = false;

  final titleController = TextEditingController();
  String category = "";
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

  Future updateLesson(
      {required String lessonId,
      required String title,
      required String category,
      required String description}) async {
    try {
      setState(() {
        isBusy = true;
      });

      final docLesson = FirebaseFirestore.instance.collection('lessons');

      await docLesson.doc(lessonId).update({
        'title': title,
        'category': category,
        'description': description,
      });
      Navigator.of(context).pop(context);
      setState(() {
        isBusy = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson edited!')),
      );
      
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      setState(() {
        isBusy = false;
      });
    }
  }

  bool isEdited() {
    if (titleController.text != widget.lesson.title ||
        category != widget.lesson.category ||
        desciptionController.text != widget.lesson.description) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                                /*===TITLE AND BACKBUTTON===*/
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
                                      child: Text("Edit the lesson",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ))),
                                ]),
                                const SizedBox(height: 30),
                                /*===TITLE TEXTFIELD===*/
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
                                /*===DROPDOWN CATEGORY FIELD===*/
                                DropdownCategory(
                                  callback: callbackCategory,
                                  categories: categories,
                                  initCategory: widget.lesson.category,
                                ),
                                const SizedBox(height: 10),
                                /*===DESCRIPTION TEXTFIELD===*/
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
                                    hintText:
                                        "Type the description of your lesson",
      
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
                                /*===SUBMIT BUTTON===*/
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
                                            if (isEdited()) {
                                              FirebaseFirestore.instance
                                                  .collection('timeslots')
                                                  .where('userId',
                                                      isEqualTo: user.uid)
                                                  .get()
                                                  .then((querySnapshot) {
                                                if (querySnapshot
                                                    .docs.isNotEmpty) {
                                                  // Do something if the document exists
                                                  updateLesson(
                                                      lessonId: widget.lesson.id!,
                                                      title: titleController.text,
                                                      category: category,
                                                      description:
                                                          desciptionController
                                                              .text);
                                                } else {
                                                  // Do something if the document does not exist
                                                  Navigator.of(context).push(
                                                      createRoute(
                                                          const HoursSelectionPage()));
                                                }
                                              });
                                            } else {
                                              Utils.showSnackBar(
                                                  "Edit at least one field");
                                            }
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
        ),
      ),
    );
  }
}
