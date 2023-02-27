import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/component/storage.dart';
import 'package:studymate/models/category.dart';
import 'package:studymate/screens/Authenticated/authenticated.dart';

import '../Search/widgets/category_card.dart';

class Intrest extends StatefulWidget {
  @override
  _IntrestState createState() => _IntrestState();
}

class _IntrestState extends State<Intrest> {
  List<String> selectedCatList = [];
  List<String> cat = [];
  Stream<List<Category>> readCategory() => FirebaseFirestore.instance
      .collection('categories')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
            padding:
                const EdgeInsets.only(top: 70, bottom: 40, left: 30, right: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(children: const [
                        Text(
                          "Your Course of interest",
                          style: TextStyle(
                            fontFamily: "Crimson Pro",
                            fontSize: 30,
                            color: Color.fromARGB(255, 233, 64, 87),
                          ),
                        ),
                        Text("Select a few of your course of interests.",
                            style: TextStyle(
                              fontFamily: "Crimson Pro",
                              fontSize: 16,
                              color: Color.fromARGB(255, 104, 104, 104),
                            ))
                      ]),
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: FutureBuilder<List<Category>>(
                          future: readCategory().first,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong!');
                            } else if (snapshot.hasData) {
                              final categories = snapshot.data!;
                              cat = [];
                              categories.forEach((item) {
                                cat.add(item.name);
                              });
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: MultiSelectChip(cat,
                                    onSelectionChanged: (selectedList) {
                                  setState(() {
                                    selectedCatList = selectedList;
                                  });
                                }),
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          })),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(35),
                      child: ElevatedButton(
                        onPressed: saveSelected,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 233, 64, 87),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: (size.width <= 550)
                              ? const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20)
                              : EdgeInsets.symmetric(
                                  horizontal: size.width * 0.2, vertical: 25),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  )
                ])));
  }

  Future saveSelected() async {
    List<Category> temp = [];
    if (selectedCatList.isNotEmpty) {
      try {
        selectedCatList.forEach((element) async {
          final cat = FirebaseFirestore.instance
              .collection('Category')
              .where('name', isEqualTo: element);

          temp.add(cat.get() as Category);
          /*var querySnapshots = await cat.get();
          var documentID;
          for (var snapshot in querySnapshots.docs) {
            documentID = snapshot.id; // <-- Document ID
          }
          print(documentID.toString());*/
        });
      } on Exception catch (e) {
        // TODO
      }
    }
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> catList;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(this.catList, {required this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    widget.catList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
