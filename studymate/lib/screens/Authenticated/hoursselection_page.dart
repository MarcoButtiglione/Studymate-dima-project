import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../component/utils.dart';

List<String> hours = [
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
List<String> day = [
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
  List<List<SelectedHourField>> selectedHourWeek=List<List<SelectedHourField>>.filled(7, [], growable: false);
  
  List<SelectedHourField> selectedHourMon = [];
  List<SelectedHourField> selectedHourTue = [];
  List<SelectedHourField> selectedHourWed = [];
  List<SelectedHourField> selectedHourThu = [];
  List<SelectedHourField> selectedHourFri = [];
  List<SelectedHourField> selectedHourSat = [];
  List<SelectedHourField> selectedHourSun = [];

  List<SelectedHourField> getListOfDay(int day) {
    List<SelectedHourField> list = [];
    switch (day) {
      case 0:
        list = selectedHourMon;
        break;
      case 1:
        list = selectedHourTue;
        break;
      case 2:
        list = selectedHourWed;
        break;
      case 3:
        list = selectedHourThu;
        break;
      case 4:
        list = selectedHourFri;
        break;
      case 5:
        list = selectedHourSat;
        break;
      case 6:
        list = selectedHourSun;
        break;
    }
    return list;
  }

  bool checkingOverlappingFrom(String newValue, int index, int day) {
    List<SelectedHourField> listToCheck = getListOfDay(day);
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
    List<SelectedHourField> listToCheck = getListOfDay(day);
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
      if (indexOfTo >= hours.indexOf(listToCheck[i].from!) &&
          indexOfTo < hours.indexOf(listToCheck[i].to!)) {
        isOverlapped = true;
      }
    }
    return isOverlapped;
  }

  void callbackRemoveForm(int day, int index) {
    //DA FARE, SE SI OVERLAPPA E ELIMINO UNO PRECEDENTE IL BOOLEANO SI BUGGA
    switch (day) {
      case 0:
        setState(() {
          selectedHourMon.removeAt(index);
        });
        break;
      case 1:
        setState(() {
          selectedHourTue.removeAt(index);
        });
        break;
      case 2:
        setState(() {
          selectedHourWed.removeAt(index);
        });
        break;
      case 3:
        setState(() {
          selectedHourThu.removeAt(index);
        });
        break;
      case 4:
        setState(() {
          selectedHourFri.removeAt(index);
        });
        break;
      case 5:
        setState(() {
          selectedHourSat.removeAt(index);
        });
        break;
      case 6:
        setState(() {
          selectedHourSun.removeAt(index);
        });
        break;
    }
  }

  void callbackSetFrom(int day, int index, String value) {
    bool isValid = true;
    List<SelectedHourField> list = getListOfDay(day);

    if (list[index].to != null) {
      if (hours.indexOf(value) >= hours.indexOf(list[index].to!)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Incorrect time entered"),
          duration: Duration(seconds: 1),
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
          duration: Duration(seconds: 1),
          backgroundColor: Color.fromARGB(255, 255, 68, 35),
        ));
        isValid = false;
      }
    }

    switch (day) {
      case 0:
        setState(() {
          selectedHourMon[index].from = value;
          selectedHourMon[index].fromIndex = hours.indexOf(value);
          selectedHourMon[index].isValid = isValid;
        });
        break;
      case 1:
        setState(() {
          selectedHourTue[index].isValid = isValid;
          selectedHourTue[index].from = value;
          selectedHourTue[index].fromIndex = hours.indexOf(value);
        });
        break;
      case 2:
        setState(() {
          selectedHourWed[index].isValid = isValid;
          selectedHourWed[index].from = value;
          selectedHourWed[index].fromIndex = hours.indexOf(value);
        });
        break;
      case 3:
        setState(() {
          selectedHourThu[index].isValid = isValid;
          selectedHourThu[index].from = value;
          selectedHourThu[index].fromIndex = hours.indexOf(value);
        });
        break;
      case 4:
        setState(() {
          selectedHourFri[index].isValid = isValid;
          selectedHourFri[index].from = value;
          selectedHourFri[index].fromIndex = hours.indexOf(value);
        });
        break;
      case 5:
        setState(() {
          selectedHourSat[index].isValid = isValid;
          selectedHourSat[index].from = value;
          selectedHourSat[index].fromIndex = hours.indexOf(value);
        });
        break;
      case 6:
        setState(() {
          selectedHourSun[index].isValid = isValid;
          selectedHourSun[index].from = value;
          selectedHourSun[index].fromIndex = hours.indexOf(value);
        });
        break;
    }
  }

  void callbackSetTo(int day, int index, String value) {
    bool isValid = true;
    List<SelectedHourField> list = getListOfDay(day);
    if (list[index].from != null) {
      if (hours.indexOf(value) <= hours.indexOf(list[index].from!)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Incorrect time entered."),
          duration: Duration(seconds: 1),
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
          duration: Duration(seconds: 1),
          backgroundColor: Color.fromARGB(255, 255, 68, 35),
        ));
        isValid = false;
      }
    }

    switch (day) {
      case 0:
        setState(() {
          selectedHourMon[index].isValid = isValid;
          selectedHourMon[index].to = value;
          selectedHourMon[index].toIndex = hours.indexOf(value);
        });
        break;
      case 1:
        setState(() {
          selectedHourTue[index].isValid = isValid;
          selectedHourTue[index].to = value;
          selectedHourTue[index].toIndex = hours.indexOf(value);
        });
        break;
      case 2:
        setState(() {
          selectedHourWed[index].isValid = isValid;
          selectedHourWed[index].to = value;
          selectedHourWed[index].toIndex = hours.indexOf(value);
        });
        break;
      case 3:
        setState(() {
          selectedHourThu[index].isValid = isValid;
          selectedHourThu[index].to = value;
          selectedHourThu[index].toIndex = hours.indexOf(value);
        });
        break;
      case 4:
        setState(() {
          selectedHourFri[index].isValid = isValid;
          selectedHourFri[index].to = value;
          selectedHourFri[index].toIndex = hours.indexOf(value);
        });
        break;
      case 5:
        setState(() {
          selectedHourSat[index].isValid = isValid;
          selectedHourSat[index].to = value;
          selectedHourSat[index].toIndex = hours.indexOf(value);
        });
        break;
      case 6:
        setState(() {
          selectedHourSun[index].isValid = isValid;
          selectedHourSun[index].to = value;
          selectedHourSun[index].toIndex = hours.indexOf(value);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              Row(children: const <Widget>[
                Text("Monday",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
              Column(
                children:
                    selectedHourMon.map<FromToField>((SelectedHourField field) {
                  return FromToField(
                      0,
                      selectedHourMon.indexOf(field),
                      field,
                      callbackRemoveForm,
                      callbackSetFrom,
                      callbackSetTo,
                      selectedHourMon.indexOf(field) ==
                          (selectedHourMon.length - 1));
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
                      if (selectedHourMon.isNotEmpty) {
                        if (selectedHourMon.last.isValid &&
                            selectedHourMon.last.from != null &&
                            selectedHourMon.last.to != null) {
                          setState(() {
                            selectedHourMon.add(SelectedHourField());
                          });
                        } else {
                          Utils.showSnackBar(
                              "Fill out the previous form first.");
                        }
                      } else {
                        setState(() {
                          selectedHourMon.add(SelectedHourField());
                        });
                      }
                    },
                    label: Text('Add a new time slot'),
                  ),
                ],
              ),
              Row(children: const <Widget>[
                Text("Tuesday",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
              Column(
                children:
                    selectedHourTue.map<FromToField>((SelectedHourField field) {
                  return FromToField(
                      1,
                      selectedHourTue.indexOf(field),
                      field,
                      callbackRemoveForm,
                      callbackSetFrom,
                      callbackSetTo,
                      selectedHourTue.indexOf(field) ==
                          (selectedHourTue.length - 1));
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
                      setState(() {
                        selectedHourTue.add(SelectedHourField());
                      });
                    },
                    label: Text('Add a new time slot'),
                  ),
                ],
              ),
              Row(children: const <Widget>[
                Text("Wednesday",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
              Column(
                children:
                    selectedHourWed.map<FromToField>((SelectedHourField field) {
                  return FromToField(
                      2,
                      selectedHourWed.indexOf(field),
                      field,
                      callbackRemoveForm,
                      callbackSetFrom,
                      callbackSetTo,
                      selectedHourWed.indexOf(field) ==
                          (selectedHourWed.length - 1));
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
                      setState(() {
                        selectedHourWed.add(SelectedHourField());
                      });
                    },
                    label: Text('Add a new time slot'),
                  ),
                ],
              ),
              Row(children: const <Widget>[
                Text("Thursday",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
              Column(
                children:
                    selectedHourThu.map<FromToField>((SelectedHourField field) {
                  return FromToField(
                      3,
                      selectedHourThu.indexOf(field),
                      field,
                      callbackRemoveForm,
                      callbackSetFrom,
                      callbackSetTo,
                      selectedHourThu.indexOf(field) ==
                          (selectedHourThu.length - 1));
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
                      setState(() {
                        selectedHourThu.add(SelectedHourField());
                      });
                    },
                    label: Text('Add a new time slot'),
                  ),
                ],
              ),
              Row(children: const <Widget>[
                Text("Friday",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
              Column(
                children:
                    selectedHourFri.map<FromToField>((SelectedHourField field) {
                  return FromToField(
                      4,
                      selectedHourFri.indexOf(field),
                      field,
                      callbackRemoveForm,
                      callbackSetFrom,
                      callbackSetTo,
                      selectedHourFri.indexOf(field) ==
                          (selectedHourFri.length - 1));
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
                      setState(() {
                        selectedHourFri.add(SelectedHourField());
                      });
                    },
                    label: Text('Add a new time slot'),
                  ),
                ],
              ),
              Row(children: const <Widget>[
                Text("Saturday",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
              Column(
                children:
                    selectedHourSat.map<FromToField>((SelectedHourField field) {
                  return FromToField(
                      5,
                      selectedHourSat.indexOf(field),
                      field,
                      callbackRemoveForm,
                      callbackSetFrom,
                      callbackSetTo,
                      selectedHourSat.indexOf(field) ==
                          (selectedHourSat.length - 1));
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
                      setState(() {
                        selectedHourSat.add(SelectedHourField());
                      });
                    },
                    label: Text('Add a new time slot'),
                  ),
                ],
              ),
              Row(children: const <Widget>[
                Text("Sunday",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
              Column(
                children:
                    selectedHourSun.map<FromToField>((SelectedHourField field) {
                  return FromToField(
                      6,
                      selectedHourSun.indexOf(field),
                      field,
                      callbackRemoveForm,
                      callbackSetFrom,
                      callbackSetTo,
                      selectedHourSun.indexOf(field) ==
                          (selectedHourSun.length - 1));
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
                      setState(() {
                        selectedHourSun.add(SelectedHourField());
                      });
                    },
                    label: Text('Add a new time slot'),
                  ),
                ],
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
                        },
                        child: const Text('Submit',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ))),
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
        )),
      ),
    );
  }
}

class DropdownHours extends StatelessWidget {
  bool isFrom;
  int day;
  int index;
  SelectedHourField valueFromTo;
  Function callback;
  bool isLastOne;

  DropdownHours(this.isFrom, this.day, this.index, this.valueFromTo,
      this.callback, this.isLastOne,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      enableFeedback: false,
      value: isFrom ? valueFromTo.from : valueFromTo.to,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "";
        }
        if (isFrom) {
          if (valueFromTo.to != null) {
            if (hours.indexOf(value) >= hours.indexOf(valueFromTo.to!)) {
              return "";
            }
          }
        } else {
          if (valueFromTo.from != null) {
            if (hours.indexOf(value) <= hours.indexOf(valueFromTo.from!)) {
              return "";
            }
          }
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        errorStyle: const TextStyle(height: 0),
        labelText: isFrom ? "From" : "To",
        hintText: "--:--",
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
      onChanged: isLastOne
          ? (String? value) {
              callback(day, index, value);
            }
          : null,
      items: hours.map<DropdownMenuItem<String>>((String hour) {
        return DropdownMenuItem<String>(
          value: hour,
          child: Text(hour),
        );
      }).toList(),
    );
  }
}

class FromToField extends StatelessWidget {
  int day;
  int index;
  SelectedHourField field;
  Function callbackRemoveForm;
  Function callbackSetFrom;
  Function callbackSetTo;
  bool isLastOne;

  FromToField(this.day, this.index, this.field, this.callbackRemoveForm,
      this.callbackSetFrom, this.callbackSetTo, this.isLastOne,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: DropdownHours(
                    true, day, index, field, callbackSetFrom, isLastOne)),
            const VerticalDivider(width: 20),
            Expanded(
                child: DropdownHours(
                    false, day, index, field, callbackSetTo, isLastOne)),
            IconButton(
              onPressed: () {
                callbackRemoveForm(day, index);
              },
              icon: const Icon(
                Icons.close,
              ),
            )
          ],
        ),
      ],
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

class ListSelectedHours {
  String day;
  List<SelectedHourField> list;
  ListSelectedHours({
    required this.day,
    required this.list,
  });
}
