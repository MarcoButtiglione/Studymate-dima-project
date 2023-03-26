import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studymate/models/timeslot.dart';

const List<String> hours = [
  "00:00",
  "01:00",
  "02:00",
  "03:00",
  "04:00",
  "05:00",
  "06:00",
  "07:00",
  "08:00",
  "09:00",
  "10:00",
  "11:00",
  "12:00",
  "13:00",
  "14:00",
  "15:00",
  "16:00",
  "17:00",
  "18:00",
  "19:00",
  "20:00",
  "21:00",
  "22:00",
  "23:00",
  "24:00",
];
const List<String> day = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

class HoursSelectionPage extends StatefulWidget {
  const HoursSelectionPage({super.key});

  @override
  State<HoursSelectionPage> createState() => _HoursSelectionPageState();
}

class _HoursSelectionPageState extends State<HoursSelectionPage> {
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;

  List<List<SelectedHourField>> selectedHourWeek = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  bool checkingOverlappingFrom(String newValue, int index, int day) {
    List<SelectedHourField> listToCheck = selectedHourWeek[day];
    bool isOverlapped = false;
    int indexOfFrom = hours.indexOf(newValue);
    if (listToCheck[index].to != null) {
      int indexOfTo = hours.indexOf(listToCheck[index].to!);
      //CONTROLLARE SE IL VALORE FROM E TO OVERLAPPANO COMPLETAMENTE INTERVALLI PRECEDENTI
      for (var i = 0; i < listToCheck.length - 1; i++) {
        if (indexOfFrom <= hours.indexOf(listToCheck[i].from!) &&
            indexOfTo >= hours.indexOf(listToCheck[i].to!)) {
          isOverlapped = true;
        }
      }
    }
    //CONTROLLARE SE IL VALORE FROM SI TROVA TRA DUE PRECEDENTI
    for (var i = 0; i < listToCheck.length - 1; i++) {
      if (indexOfFrom >= hours.indexOf(listToCheck[i].from!) &&
          indexOfFrom < hours.indexOf(listToCheck[i].to!)) {
        isOverlapped = true;
      }
    }
    return isOverlapped;
  }

  bool checkingOverlappingTo(String newValue, int index, int day) {
    List<SelectedHourField> listToCheck = selectedHourWeek[day];
    bool isOverlapped = false;
    int indexOfTo = hours.indexOf(newValue);
    if (listToCheck[index].from != null) {
      int indexOfFrom = hours.indexOf(listToCheck[index].from!);
      //CONTROLLARE SE IL VALORE FROM E TO OVERLAPPANO COMPLETAMENTE INTERVALLI PRECEDENTI
      for (var i = 0; i < listToCheck.length - 1; i++) {
        if (indexOfFrom <= hours.indexOf(listToCheck[i].from!) &&
            indexOfTo >= hours.indexOf(listToCheck[i].to!)) {
          isOverlapped = true;
        }
      }
    }
    //CONTROLLARE SE IL VALORE FROM SI TROVA TRA DUE PRECEDENTI
    for (var i = 0; i < listToCheck.length - 1; i++) {
      if (indexOfTo > hours.indexOf(listToCheck[i].from!) &&
          indexOfTo <= hours.indexOf(listToCheck[i].to!)) {
        isOverlapped = true;
      }
    }
    return isOverlapped;
  }

  void callbackRemoveForm(int day, int index) {
    //DA FARE, SE SI OVERLAPPA E ELIMINO UNO PRECEDENTE IL BOOLEANO SI BUGGA
    setState(() {
      selectedHourWeek[day].removeAt(index);
    });
  }

  void callbackSetFrom(int day, int index, String value) {
    bool isValid = true;
    List<SelectedHourField> list = selectedHourWeek[day];

    if (list[index].to != null) {
      if (hours.indexOf(value) >= hours.indexOf(list[index].to!)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Incorrect time entered"),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 255, 68, 35),
        ));

        isValid = false;
      }
    }
    if (list.length >= 2) {
      bool isOverlapped = checkingOverlappingFrom(value, index, day);
      if (isOverlapped) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Incorrect time entered. Possible overlaps."),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 255, 68, 35),
        ));
        isValid = false;
      }
    }
    setState(() {
      selectedHourWeek[day][index].from = value;
      selectedHourWeek[day][index].fromIndex = hours.indexOf(value);
      selectedHourWeek[day][index].isValid = isValid;
    });
  }

  void callbackSetTo(int day, int index, String value) {
    bool isValid = true;
    List<SelectedHourField> list = selectedHourWeek[day];
    if (list[index].from != null) {
      if (hours.indexOf(value) <= hours.indexOf(list[index].from!)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Incorrect time entered."),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 255, 68, 35),
        ));
        isValid = false;
      }
    }
    if (list.length >= 2) {
      bool isOverlapped = checkingOverlappingTo(value, index, day);
      if (isOverlapped) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Incorrect time entered. Possible overlaps."),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 255, 68, 35),
        ));
        isValid = false;
      }
    }
    setState(() {
      selectedHourWeek[day][index].isValid = isValid;
      selectedHourWeek[day][index].to = value;
      selectedHourWeek[day][index].toIndex = hours.indexOf(value);
    });
  }

  Future send() async {
    try {
      String docId = "";
      final docTimeslot = FirebaseFirestore.instance.collection('timeslots');
      await docTimeslot.add({}).then((DocumentReference doc) {
        docId = doc.id;
      });

      TimeslotsWeek timeslotsWeek = TimeslotsWeek(userId: user.uid, week: {
        "Monday": [],
        "Tuesday": [],
        "Wednesday": [],
        "Thursday": [],
        "Friday": [],
        "Saturday": [],
        "Sunday": [],
      });
      for (var i = 0; i < selectedHourWeek.length; i++) {
        List<SelectedHourField> selectedHourDay = selectedHourWeek[i];
        String dayString = day[i];
        print(dayString);
        //DA FARE IL CHECK SE CAMPI NULLI
        selectedHourDay.sort((a, b) => a.fromIndex!.compareTo(b.fromIndex!));

        for (var j = 0; j < selectedHourDay.length; j++) {
          SelectedHourField selectedHourField = selectedHourDay[j];

          for (var k = selectedHourField.fromIndex!;
              k < selectedHourField.toIndex!;
              k++) {
            timeslotsWeek.week[dayString]!.add({
              "timeslot": hours[k] + " - " + hours[k + 1],
              "isOccupied": false,
              "lessonIdOccupied": "",
            });
          }
        }
      }
      final json = timeslotsWeek.toFirestore();
      await docTimeslot.doc(docId).set(json);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time slots added!')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Fill out the previous form first."),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 255, 68, 35),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Row(children: const <Widget>[
                  Text("Select your free time",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                ]),
                const Text(
                    "Before creating your first lesson, enter the time slots of the week when you would be free to give lessons.",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 13)),
                const SizedBox(height: 30),
                Column(
                  children: selectedHourWeek
                      .map<Column>((List<SelectedHourField> selectedHour) {
                    return Column(
                      children: [
                        Row(children: <Widget>[
                          Text(day[selectedHourWeek.indexOf(selectedHour)],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ]),
                        Column(
                          children: selectedHour
                              .map<Column>((SelectedHourField field) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    /*
                                      FROM DROPDOWN
                                    */
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        enableFeedback: false,
                                        value: field.from,
                                        validator: (value) {
                                          if (selectedHour.indexOf(field) ==
                                              (selectedHour.length - 1)) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return null;
                                            }

                                            if (field.to != null) {
                                              if (hours.indexOf(value) >=
                                                  hours.indexOf(field.to!)) {
                                                return "";
                                              }
                                            }

                                            if (checkingOverlappingFrom(
                                                value,
                                                selectedHour.indexOf(field),
                                                selectedHourWeek
                                                    .indexOf(selectedHour))) {
                                              return "";
                                            }
                                          }
                                          return null;
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          errorStyle:
                                              const TextStyle(height: 0),
                                          labelText: "From",
                                          hintText: "--:--",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                        ),
                                        onChanged: selectedHour
                                                    .indexOf(field) ==
                                                (selectedHour.length - 1)
                                            ? (String? value) {
                                                if (value != null) {
                                                  callbackSetFrom(
                                                      selectedHourWeek.indexOf(
                                                          selectedHour),
                                                      selectedHour
                                                          .indexOf(field),
                                                      value);
                                                }
                                              }
                                            : null,
                                        items: hours
                                            .map<DropdownMenuItem<String>>(
                                                (String hour) {
                                          return DropdownMenuItem<String>(
                                            value: hour,
                                            child: Text(hour),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const VerticalDivider(width: 20),
                                    /*
                                      TO DROPDOWN
                                    */
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        enableFeedback: false,
                                        value: field.to,
                                        validator: (value) {
                                          if (selectedHour.indexOf(field) ==
                                              (selectedHour.length - 1)) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return null;
                                            }

                                            if (field.from != null) {
                                              if (hours.indexOf(value) <=
                                                  hours.indexOf(field.from!)) {
                                                return "";
                                              }
                                            }
                                            if (checkingOverlappingTo(
                                                value,
                                                selectedHour.indexOf(field),
                                                selectedHourWeek
                                                    .indexOf(selectedHour))) {
                                              return "";
                                            }
                                          }
                                          return null;
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          errorStyle:
                                              const TextStyle(height: 0),
                                          labelText: "To",
                                          hintText: "--:--",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                        ),
                                        onChanged: selectedHour
                                                    .indexOf(field) ==
                                                (selectedHour.length - 1)
                                            ? (String? value) {
                                                if (value != null) {
                                                  callbackSetTo(
                                                      selectedHourWeek.indexOf(
                                                          selectedHour),
                                                      selectedHour
                                                          .indexOf(field),
                                                      value);
                                                }
                                              }
                                            : null,
                                        items: hours
                                            .map<DropdownMenuItem<String>>(
                                                (String hour) {
                                          return DropdownMenuItem<String>(
                                            value: hour,
                                            child: Text(hour),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        callbackRemoveForm(
                                            selectedHourWeek
                                                .indexOf(selectedHour),
                                            selectedHour.indexOf(field));
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              icon: const Icon(
                                Icons.add,
                              ),
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 15),
                              ),
                              onPressed: () {
                                if (selectedHour.isNotEmpty) {
                                  if (selectedHour.last.isValid &&
                                      selectedHour.last.from != null &&
                                      selectedHour.last.to != null) {
                                    setState(() {
                                      selectedHour.add(SelectedHourField());
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Fill out the previous form first."),
                                      duration: Duration(seconds: 2),
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 68, 35),
                                    ));
                                  }
                                } else {
                                  setState(() {
                                    selectedHour.add(SelectedHourField());
                                  });
                                }
                              },
                              label: Text('Add a new time slot'),
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 233, 64, 87),
                        ),
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            bool isValid = true;
                            bool isEmpty = true;
                            for (var selectedHour in selectedHourWeek) {
                              if (selectedHour.isNotEmpty) {
                                isEmpty = false;
                                if (!selectedHour.last.isValid ||
                                    selectedHour.last.from == null ||
                                    selectedHour.last.to == null) {
                                  isValid = false;
                                }
                              }
                            }
                            if (!isEmpty) {
                              if (isValid) {
                                send();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Fill out all the previous fields first."),
                                  duration: Duration(seconds: 2),
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 68, 35),
                                ));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Please enter at least one valid field."),
                                duration: Duration(seconds: 2),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 68, 35),
                              ));
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Some invalid fields."),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color.fromARGB(255, 255, 68, 35),
                            ));
                          }
                        },
                        child: const Text('Submit',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            )),
                      ),
                    ),
                  ],
                ),

                /*
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 0.0, // gap between lines
                  children: <Widget>[
                    
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('01:00 - 02:00'),
                    ),
                    Chip(
                      label: const Text('03:00 - 04:00'),
                    ),
                    Chip(
                      label: const Text('04:00 - 05:00'),
                    ),
                    Chip(
                      label: const Text('05:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('06:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('07:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('08:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('09:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                    Chip(
                      label: const Text('00:00 - 01:00'),
                    ),
                  ],
                )
                */
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class SelectedHourField {
  String? from;
  String? to;
  int? fromIndex;
  int? toIndex;
  bool isValid = true;
  SelectedHourField();
}