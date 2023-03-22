import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studymate/models/lesson.dart';
import 'package:studymate/screens/Authenticated/hoursselection_page.dart';

import '../../component/utils.dart';
import '../../functions/routingAnimation.dart';
import '../../models/category.dart';

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

  void callbackStartingTime(String startingTime) {
    setState(() {
      this.startingTime = startingTime;
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
      await docLesson.add({}).then((DocumentReference doc) {
        docId = doc.id;
      });
      final json = lesson.toFirestore();
      await docLesson.doc(docId).set(json);
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
                            DropdownCategory(callbackCategory, categories),
                            /*
                            DataPicker(callbackDate),
                            const SizedBox(height: 10),
                            StartingTimePicker(callbackStartingTime),
                            const SizedBox(height: 10),
                            Row(
                              children: const [
                                Text("Lesson duration",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 9,
                                  child: SliderDuration(callbackDuration),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    duration.toString() + "h",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            */
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
                                        Navigator.of(context).push(createRoute(
                                            const HoursSelectionPage()));
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
                        ;
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

class DropdownCategory extends StatefulWidget {
  Function callback;
  List<Category> categories;
  DropdownCategory(this.callback, this.categories, {super.key});

  @override
  State<DropdownCategory> createState() => _DropdownCategoryState();
}

class _DropdownCategoryState extends State<DropdownCategory> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonFormField<String>(
        value: dropdownValue,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a category';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: "Category",
          hintText: "Select the category of your lesson",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
          widget.callback(value);
        },
        items: widget.categories
            .map<DropdownMenuItem<String>>((Category category) {
          return DropdownMenuItem<String>(
            value: category.name,
            child: Text(category.name),
          );
        }).toList(),
      ),
    );
  }
}

class DataPicker extends StatefulWidget {
  Function callback;
  DataPicker(this.callback, {super.key});

  @override
  State<DataPicker> createState() => _DataPickerState();
}

class _DataPickerState extends State<DataPicker> {
  TextEditingController _date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a date';
        }
        return null;
      },
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _date,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.calendar_today_rounded,
          color: const Color.fromARGB(255, 233, 64, 87),
        ),
        labelText: "Date",
        hintText: "Select the date of your lesson",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      onTap: () async {
        DateTime? pickeddate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100));
        if (pickeddate != null) {
          setState(() {
            _date.text = DateFormat('yyyy-MM-dd').format(pickeddate);
          });
          widget.callback(DateFormat('yyyy-MM-dd').format(pickeddate));
        }
      },
    );
  }
}

class StartingTimePicker extends StatefulWidget {
  Function callback;
  StartingTimePicker(this.callback, {super.key});

  @override
  State<StartingTimePicker> createState() => _StartingTimePickerState();
}

class _StartingTimePickerState extends State<StartingTimePicker> {
  TextEditingController _date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _date,
      readOnly: true,
      keyboardType: TextInputType.datetime,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a starting time';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.timer_outlined,
          color: const Color.fromARGB(255, 233, 64, 87),
        ),
        labelText: "Starting time",
        hintText: "Select the starting time of your lesson",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      onTap: () async {
        TimeOfDay? pickeddate = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());
        if (pickeddate != null) {
          setState(() {
            _date.text = pickeddate.format(context);
          });
          widget.callback(pickeddate.format(context));
        }
      },
    );
  }
}

class SliderDuration extends StatefulWidget {
  Function callback;
  SliderDuration(this.callback, {super.key});

  @override
  State<SliderDuration> createState() => _SliderDurationState();
}

class _SliderDurationState extends State<SliderDuration> {
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: 1,
      max: 10,
      divisions: 10,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
        widget.callback(value.toInt());
      },
    );
  }
}
