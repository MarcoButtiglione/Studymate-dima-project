import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class HoursSelectionPage extends StatefulWidget {
  const HoursSelectionPage({super.key});

  @override
  State<HoursSelectionPage> createState() => _HoursSelectionPageState();
}

class _HoursSelectionPageState extends State<HoursSelectionPage> {
  List<List<SelectedHourField>> selectedHour =
      List<List<SelectedHourField>>.filled(7, [], growable: false);

  void callbackRemoveForm(int day, int index) {
    setState(() {
      selectedHour[day].removeAt(index);
    });
  }

  void callbackSetFrom(int day, int index, String value) {
    setState(() {
      selectedHour[day][index].from = value;
    });
  }

  void callbackSetTo(int day, int index, String value) {
    setState(() {
      selectedHour[day][index].to = value;
    });
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
                    selectedHour[0].map<FromToField>((SelectedHourField field) {
                  return FromToField(0, selectedHour[0].indexOf(field), field,
                      callbackRemoveForm, callbackSetFrom, callbackSetTo);
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
                        selectedHour[0].add(SelectedHourField());
                      });
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
                    selectedHour[1].map<FromToField>((SelectedHourField field) {
                  return FromToField(1, selectedHour[1].indexOf(field), field,
                      callbackRemoveForm, callbackSetFrom, callbackSetTo);
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
                        selectedHour[1].add(SelectedHourField());
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
                    selectedHour[2].map<FromToField>((SelectedHourField field) {
                  return FromToField(2, selectedHour[2].indexOf(field), field,
                      callbackRemoveForm, callbackSetFrom, callbackSetTo);
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
                        selectedHour[2].add(SelectedHourField());
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
                    selectedHour[3].map<FromToField>((SelectedHourField field) {
                  return FromToField(3, selectedHour[3].indexOf(field), field,
                      callbackRemoveForm, callbackSetFrom, callbackSetTo);
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
                        selectedHour[3].add(SelectedHourField());
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
                    selectedHour[4].map<FromToField>((SelectedHourField field) {
                  return FromToField(4, selectedHour[4].indexOf(field), field,
                      callbackRemoveForm, callbackSetFrom, callbackSetTo);
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
                        selectedHour[4].add(SelectedHourField());
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
                    selectedHour[5].map<FromToField>((SelectedHourField field) {
                  return FromToField(5, selectedHour[5].indexOf(field), field,
                      callbackRemoveForm, callbackSetFrom, callbackSetTo);
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
                        selectedHour[5].add(SelectedHourField());
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
                    selectedHour[6].map<FromToField>((SelectedHourField field) {
                  return FromToField(6, selectedHour[6].indexOf(field), field,
                      callbackRemoveForm, callbackSetFrom, callbackSetTo);
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
                        selectedHour[6].add(SelectedHourField());
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
  String? value;
  Function callback;
  DropdownHours(this.isFrom, this.day, this.index, this.value, this.callback,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      enableFeedback: false,
      value: value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
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
      onChanged: (String? value) {
        // This is called when the user selects an item.
        callback(day, index, value);
        //widget.callback(value);
      },
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

  FromToField(this.day, this.index, this.field, this.callbackRemoveForm,
      this.callbackSetFrom, this.callbackSetTo,
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
                    true, day, index, field.from, callbackSetFrom)),
            const VerticalDivider(width: 20),
            Expanded(
                child:
                    DropdownHours(false, day, index, field.to, callbackSetTo)),
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
  SelectedHourField();
}
