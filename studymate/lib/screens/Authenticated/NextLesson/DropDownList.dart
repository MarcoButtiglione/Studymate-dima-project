import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DropdownCategory extends StatefulWidget {
  Function callback;
  Function(String) onChanged;

  DropdownCategory(this.callback, {super.key, required this.onChanged});

  @override
  State<DropdownCategory> createState() => _DropdownCategoryState();
}

class _DropdownCategoryState extends State<DropdownCategory> {
  String? dropdownValue;
  List<String> categories = [];
  final CollectionReference _catRef =
      FirebaseFirestore.instance.collection('categories');

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    List<String> c = [];
    c.add("Category");
    QuerySnapshot querySnapshot = await _catRef.get();
   // var allData = 
    querySnapshot.docs.map((doc) {
      c.add(doc.get("name"));
    }).toList();
    setState(
      () {
        categories = c;
      },
    );
  }

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
            widget.onChanged(value);
          });
          widget.callback(value);
        },
        items: categories.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
