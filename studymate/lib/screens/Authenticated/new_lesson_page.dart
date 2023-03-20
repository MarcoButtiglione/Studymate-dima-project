import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final titleController = TextEditingController();
  String? category;
  String? date;
  String? startingTime;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: StreamBuilder<List<Category>>(
            stream: readCategory(),
            builder: (context, snapshot) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Row(children: const <Widget>[
                    Text("Create a lesson",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                  ]),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: "Title",
                      hintText: "Type the title of your lesson",
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
                  ),
                  const SizedBox(height: 10),
                  DropdownCategory(callbackCategory),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: desciptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: 5,
                    decoration: InputDecoration(
                      //labelText: "Description",
                      hintText: "Type the description of your lesson",
          
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
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        print(titleController.text);
                        print(category);
                        print(date);
                        print(startingTime);
                        print(duration);
                        print(desciptionController.text);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class DropdownCategory extends StatefulWidget {
  Function callback;
  DropdownCategory(this.callback, {super.key});

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
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
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
        icon: const Icon(Icons.calendar_today_rounded),
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
            firstDate: DateTime(2000),
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
        icon: const Icon(Icons.timer_outlined),
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
