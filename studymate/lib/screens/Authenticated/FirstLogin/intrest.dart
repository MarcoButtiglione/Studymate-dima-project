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
  List<Category> selected = [];
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
            padding: EdgeInsets.only(top: 50, bottom: 40, left: 30, right: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
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
                      flex: 7,
                      child: FutureBuilder<List<Category>>(
                          future: readCategory().first,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong!');
                            } else if (snapshot.hasData) {
                              final categories = snapshot.data!;
                              return GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: (1 / .4),
                                  children:
                                      categories.map(buildCategory).toList());
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          })),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(35),
                      child: ElevatedButton(
                        onPressed: () => {},
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

  Widget buildCategory(Category cat) => Container(
        height: 10,
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: (selected.contains(cat))
                ? const Color.fromARGB(255, 233, 64, 87)
                : const Color.fromARGB(255, 255, 255, 255),
            border: Border.all(
              color: const Color.fromARGB(255, 233, 64, 87),
              width: 3,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
            child: TextButton(
          onPressed: () {
            setState(() {
              selected.add(cat);
              print(selected[0].name);
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: (selected.contains(cat))
                ? const Color.fromARGB(255, 233, 64, 87)
                : const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(cat.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: (selected.contains(cat))
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 233, 64, 87),
              )),
        )),
      );

  /* Future addInterest() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      final docUser = FirebaseFirestore.instance.collection('users').doc();
      final addUser = Users(
          id: user.uid,
          firstname: firstnameControler.text.trim(),
          lastname: lastnameControler.text.trim(),
          profileImageURL: imgUrl);
      final json = addUser.toJson();
      await docUser.set(json);

      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Intrest()));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }*/
}
