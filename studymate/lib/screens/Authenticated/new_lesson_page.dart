import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewLessonPage extends StatefulWidget {
  @override
  State<NewLessonPage> createState() => _NewLessonPageState();
}

class _NewLessonPageState extends State<NewLessonPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(children: const <Widget>[
              Expanded(
                flex: 9,
                child: Text("Create a lesson",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ]),
            const SizedBox(height: 20),
            TextFormField(
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
            DropdownButtonExample(),
            const SizedBox(height: 10),
            DataPicker(),
            const SizedBox(height: 10),
            StartingTimePicker(),
            const SizedBox(height: 10),
            SliderExample(),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Description",
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
          ],
        ),
      ),
    );
  }
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonFormField<String>(
        value: dropdownValue,
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
  const DataPicker({super.key});

  @override
  State<DataPicker> createState() => _DataPickerState();
}

class _DataPickerState extends State<DataPicker> {
  TextEditingController _date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        }
      },
    );
  }
}

class StartingTimePicker extends StatefulWidget {
  const StartingTimePicker({super.key});

  @override
  State<StartingTimePicker> createState() => _StartingTimePickerState();
}

class _StartingTimePickerState extends State<StartingTimePicker> {
  TextEditingController _date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _date,
      keyboardType: TextInputType.datetime,
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
        }
      },
    );
  }
}

class SliderExample extends StatefulWidget {
  const SliderExample({super.key});

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      max: 24,
      divisions: 24,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}
