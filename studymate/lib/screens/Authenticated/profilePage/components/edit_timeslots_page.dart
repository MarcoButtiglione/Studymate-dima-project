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

class EditTimeslotsPage extends StatefulWidget {
  final TimeslotsWeek timeslots;
  const EditTimeslotsPage({super.key, required this.timeslots});

  @override
  State<EditTimeslotsPage> createState() => _EditTimeslotsPageState();
}

class _EditTimeslotsPageState extends State<EditTimeslotsPage> {
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  bool isBusy = false;

  List<List<SelectedHourField>> selectedHourWeek = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  @override
  void initState() {
    super.initState();
    initSelectedHourWeek();
  }

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
      setState(() {
        isBusy = true;
      });
      TimeslotsWeek timeslotsWeek = TimeslotsWeek(
        id: widget.timeslots.id,
        userId: user.uid,
        monday: [],
        tuesday: [],
        wednesday: [],
        thursday: [],
        friday: [],
        saturday: [],
        sunday: [],
      );
      for (var i = 0; i < selectedHourWeek.length; i++) {
        List<SelectedHourField> selectedHourDay = selectedHourWeek[i];
        List<String> day = [];
        //DA FARE IL CHECK SE CAMPI NULLI
        selectedHourDay.sort((a, b) => a.fromIndex!.compareTo(b.fromIndex!));

        for (var j = 0; j < selectedHourDay.length; j++) {
          SelectedHourField selectedHourField = selectedHourDay[j];

          for (var k = selectedHourField.fromIndex!;
              k < selectedHourField.toIndex!;
              k++) {
            day.add("${hours[k]} - ${hours[k + 1]}");
          }
        }
        switch (i) {
          case 0:
            timeslotsWeek.monday = day;
            break;
          case 1:
            timeslotsWeek.tuesday = day;
            break;
          case 2:
            timeslotsWeek.wednesday = day;
            break;
          case 3:
            timeslotsWeek.thursday = day;
            break;
          case 4:
            timeslotsWeek.friday = day;
            break;
          case 5:
            timeslotsWeek.saturday = day;
            break;
          case 6:
            timeslotsWeek.sunday = day;
            break;
        }
      }
      String docId = widget.timeslots.id!;
      final docTimeslot = FirebaseFirestore.instance.collection('timeslots');
      await docTimeslot.doc(docId).update({
        'monday': timeslotsWeek.monday,
        'tuesday': timeslotsWeek.tuesday,
        'wednesday': timeslotsWeek.wednesday,
        'thursday': timeslotsWeek.thursday,
        'friday': timeslotsWeek.friday,
        'saturday': timeslotsWeek.saturday,
        'sunday': timeslotsWeek.sunday,
      });

      Navigator.pop(context);
      setState(() {
        isBusy = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time slots added!')),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isBusy = false;
      });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Fill out the previous form first."),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 255, 68, 35),
      ));
    }
  }

  List<String> convertListTimestampToPrint(List<dynamic> list) {
    List<String> timeToPrint = [];
    String? firstTimestamp;
    //Se c'è solo un elemento nel vettore
    if (list.length == 1) {
      timeToPrint.add(list[0]);
    }
    //Se ce ne sono almeno 2
    else {
      //Qui gestisco tutti gli elementi del vettore tranne l'ultimo
      for (var i = 0; i < list.length - 1; i++) {
        String x = list[i];
        String y = list[i + 1];
        int xInt = int.parse(x.substring(0, 2));
        int yInt = int.parse(y.substring(0, 2));

        //Se è il timestamp successivo
        if (xInt == (yInt - 1)) {
          //Se era vuoto (e quindi avevo aggiunto già un elemento nella lista) aggiungo l'attuale valore
          //altrimenti scorri il vettore
          firstTimestamp ??= x.substring(0, 5);
        }
        //Se il non è il timestamp successivo
        else {
          if (firstTimestamp == null) {
            timeToPrint.add(x);
          } else {
            timeToPrint.add(firstTimestamp + " - " + x.substring(8, 13));
            firstTimestamp = null;
          }
        }
      }
      //Uscito dalla lista rimarrà l'ultimo
      //Se era vuoto vuol dire che avevo già aggiunto in timeToPrint
      if (firstTimestamp == null) {
        timeToPrint.add(list[list.length - 1]);
      } else {
        String x = list[list.length - 1];
        timeToPrint.add(firstTimestamp + " - " + x.substring(8, 13));
      }
    }
    return timeToPrint;
  }

  void initSelectedHourWeek() {
    if (widget.timeslots.monday.isNotEmpty) {
      List<String> monday =
          convertListTimestampToPrint(widget.timeslots.monday);
      for (var element in monday) {
        SelectedHourField shf = SelectedHourField();
        shf.from = element.substring(0, 5);
        shf.fromIndex = hours.indexOf(element.substring(0, 5));
        shf.to = element.substring(8, 13);
        shf.toIndex = hours.indexOf(element.substring(8, 13));
        shf.isValid = true;
        setState(() {
          selectedHourWeek[0].add(shf);
        });
      }
    }
    if (widget.timeslots.tuesday.isNotEmpty) {
      List<String> tuesday =
          convertListTimestampToPrint(widget.timeslots.tuesday);
      for (var element in tuesday) {
        SelectedHourField shf = SelectedHourField();
        shf.from = element.substring(0, 5);
        shf.fromIndex = hours.indexOf(element.substring(0, 5));
        shf.to = element.substring(8, 13);
        shf.toIndex = hours.indexOf(element.substring(8, 13));
        shf.isValid = true;
        setState(() {
          selectedHourWeek[1].add(shf);
        });
      }
    }
    if (widget.timeslots.wednesday.isNotEmpty) {
      List<String> wednesday =
          convertListTimestampToPrint(widget.timeslots.wednesday);
      for (var element in wednesday) {
        SelectedHourField shf = SelectedHourField();
        shf.from = element.substring(0, 5);
        shf.fromIndex = hours.indexOf(element.substring(0, 5));
        shf.to = element.substring(8, 13);
        shf.toIndex = hours.indexOf(element.substring(8, 13));
        shf.isValid = true;
        setState(() {
          selectedHourWeek[2].add(shf);
        });
      }
    }
    if (widget.timeslots.thursday.isNotEmpty) {
      List<String> thursday =
          convertListTimestampToPrint(widget.timeslots.thursday);
      for (var element in thursday) {
        SelectedHourField shf = SelectedHourField();
        shf.from = element.substring(0, 5);
        shf.fromIndex = hours.indexOf(element.substring(0, 5));
        shf.to = element.substring(8, 13);
        shf.toIndex = hours.indexOf(element.substring(8, 13));
        shf.isValid = true;
        setState(() {
          selectedHourWeek[3].add(shf);
        });
      }
    }
    if (widget.timeslots.friday.isNotEmpty) {
      List<String> friday =
          convertListTimestampToPrint(widget.timeslots.friday);
      for (var element in friday) {
        SelectedHourField shf = SelectedHourField();
        shf.from = element.substring(0, 5);
        shf.fromIndex = hours.indexOf(element.substring(0, 5));
        shf.to = element.substring(8, 13);
        shf.toIndex = hours.indexOf(element.substring(8, 13));
        shf.isValid = true;
        setState(() {
          selectedHourWeek[4].add(shf);
        });
      }
    }
    if (widget.timeslots.saturday.isNotEmpty) {
      List<String> saturday =
          convertListTimestampToPrint(widget.timeslots.saturday);
      for (var element in saturday) {
        SelectedHourField shf = SelectedHourField();
        shf.from = element.substring(0, 5);
        shf.fromIndex = hours.indexOf(element.substring(0, 5));
        shf.to = element.substring(8, 13);
        shf.toIndex = hours.indexOf(element.substring(8, 13));
        shf.isValid = true;
        setState(() {
          selectedHourWeek[5].add(shf);
        });
      }
    }
    if (widget.timeslots.sunday.isNotEmpty) {
      List<String> sunday =
          convertListTimestampToPrint(widget.timeslots.sunday);
      for (var element in sunday) {
        SelectedHourField shf = SelectedHourField();
        shf.from = element.substring(0, 5);
        shf.fromIndex = hours.indexOf(element.substring(0, 5));
        shf.to = element.substring(8, 13);
        shf.toIndex = hours.indexOf(element.substring(8, 13));
        shf.isValid = true;
        setState(() {
          selectedHourWeek[6].add(shf);
        });
      }
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
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Row(children: <Widget>[
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            )),
                        const Text("Edit timeslots",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                      ]),
                      const SizedBox(height: 30),
                      Column(
                        children: selectedHourWeek.map<Column>(
                            (List<SelectedHourField> selectedHour) {
                          return Column(
                            children: [
                              Row(children: <Widget>[
                                Text(
                                    day[selectedHourWeek.indexOf(selectedHour)],
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
                                            child:
                                                DropdownButtonFormField<String>(
                                              enableFeedback: false,
                                              value: field.from,
                                              validator: (value) {
                                                if (selectedHour
                                                        .indexOf(field) ==
                                                    (selectedHour.length - 1)) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return null;
                                                  }

                                                  if (field.to != null) {
                                                    if (hours.indexOf(value) >=
                                                        hours.indexOf(
                                                            field.to!)) {
                                                      return "";
                                                    }
                                                  }

                                                  if (checkingOverlappingFrom(
                                                      value,
                                                      selectedHour
                                                          .indexOf(field),
                                                      selectedHourWeek.indexOf(
                                                          selectedHour))) {
                                                    return "";
                                                  }
                                                }
                                                return null;
                                              },
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
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
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[300]!),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
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
                                                            selectedHourWeek
                                                                .indexOf(
                                                                    selectedHour),
                                                            selectedHour
                                                                .indexOf(field),
                                                            value);
                                                      }
                                                    }
                                                  : null,
                                              items: hours.map<
                                                      DropdownMenuItem<String>>(
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
                                            child:
                                                DropdownButtonFormField<String>(
                                              enableFeedback: false,
                                              value: field.to,
                                              validator: (value) {
                                                if (selectedHour
                                                        .indexOf(field) ==
                                                    (selectedHour.length - 1)) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return null;
                                                  }

                                                  if (field.from != null) {
                                                    if (hours.indexOf(value) <=
                                                        hours.indexOf(
                                                            field.from!)) {
                                                      return "";
                                                    }
                                                  }
                                                  if (checkingOverlappingTo(
                                                      value,
                                                      selectedHour
                                                          .indexOf(field),
                                                      selectedHourWeek.indexOf(
                                                          selectedHour))) {
                                                    return "";
                                                  }
                                                }
                                                return null;
                                              },
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
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
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[300]!),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
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
                                                            selectedHourWeek
                                                                .indexOf(
                                                                    selectedHour),
                                                            selectedHour
                                                                .indexOf(field),
                                                            value);
                                                      }
                                                    }
                                                  : null,
                                              items: hours.map<
                                                      DropdownMenuItem<String>>(
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
                                            selectedHour
                                                .add(SelectedHourField());
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                "Fill out the previous form first."),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Color.fromARGB(
                                                255, 255, 68, 35),
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
                                if(isBusy){
                                  return;
                                }
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
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 68, 35),
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
