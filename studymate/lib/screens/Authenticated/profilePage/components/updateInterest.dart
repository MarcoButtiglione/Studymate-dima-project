import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../component/utils.dart';
import '../../../../models/category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class updateInterest extends StatefulWidget {
  final List<String> interest;
  final bool isOpenedRight;
  final Function callbackClosePage;

  const updateInterest(
      {super.key,
      required this.interest,
      required this.isOpenedRight,
      required this.callbackClosePage});
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
    double h = size.height;
    double w = size.width;
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(40),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(children: [
                      IconButton(
                          onPressed: () {
                            widget.callbackClosePage(widget.isOpenedRight);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                          )),
                      Text(
                        AppLocalizations.of(context)!.yourInterestsTitle,
                        style: TextStyle(
                          fontFamily: "Crimson Pro",
                          fontSize: 40,
                          color: Color.fromARGB(255, 233, 64, 87),
                        ),
                      ),
                    ]),
                    Text(AppLocalizations.of(context)!.yourInterestsSubTitle,
                        style: TextStyle(
                          fontFamily: "Crimson Pro",
                          fontSize: 20,
                          color: Color.fromARGB(255, 104, 104, 104),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<List<Category>>(
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
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 0.03 * h, left: 0.03 * h, right: 0.03 * h),
                      height: 0.08 * h,
                      width: 0.8 * w,
                      child: ElevatedButton(
                        onPressed: saveSelected,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 233, 64, 87),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.continueText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (w > 490 && h > 720) ? 30 : 16,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    )
                  ]),
            )));
  }

  Future saveSelected() async {

    try {
      if (selectedCatList.isNotEmpty) {
        final docUser =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        await docUser.set(
            {'categoriesOfInterest': selectedCatList}, SetOptions(merge: true));
        // ignore: use_build_context_synchronously
        widget.callbackClosePage(widget.isOpenedRight);
      } else {
        Utils.showSnackBar(AppLocalizations.of(context)!.selectOneSubject);
        widget.callbackClosePage(widget.isOpenedRight);
      }
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      widget.callbackClosePage(widget.isOpenedRight);
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
        padding: const EdgeInsets.all(5.0),
        child: ChoiceChip(
          label: Text(
            item,
            style: TextStyle(
              fontSize: (MediaQuery.of(context).size.width > 490 &&
                      MediaQuery.of(context).size.height > 720)
                  ? 25
                  : 16,
            ),
          ),
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
