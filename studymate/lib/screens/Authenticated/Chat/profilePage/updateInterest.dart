import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/models/user.dart';

import '../../../../component/utils.dart';
import '../../../../models/category.dart';

class updateInterest extends StatefulWidget {
  final List<String> interest;

  const updateInterest({super.key, required this.interest});
  @override
  _IntrestState createState() => _IntrestState();
}

class _IntrestState extends State<updateInterest> {
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
                      child: Column(children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                )),
                            const Text(
                              "Your Course of interest",
                              style: TextStyle(
                                fontFamily: "Crimson Pro",
                                fontSize: 25,
                                color: Color.fromARGB(255, 233, 64, 87),
                              ),
                            ),
                          ],
                        ),
                        const Text("Select a few of your course of interests.",
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
                                child: MultiSelectChip(
                                  cat,
                                  widget.interest,
                                  onSelectionChanged: (selectedList) {
                                    setState(() {
                                      selectedCatList = selectedList;
                                    });
                                  },
                                ),
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
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      if (selectedCatList.isNotEmpty) {
        final docUser =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        await docUser.set(
            {'categoriesOfInterest': selectedCatList}, SetOptions(merge: true));
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        Utils.showSnackBar("select at least one course of interest");
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> interest;
  final List<String> catList;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(this.catList, this.interest,
      {required this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];
  final user = FirebaseAuth.instance.currentUser!;
  _buildChoiceList() {
    //selectedChoices = widget.catInterest!;
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
  initState() {
    super.initState();
    selectedChoices = widget.interest;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
