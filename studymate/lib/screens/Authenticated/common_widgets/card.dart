import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studymate/models/notification.dart';
import 'package:studymate/screens/Authenticated/qrCode/qrCodeGenerate.dart';
import 'package:studymate/screens/Authenticated/qrCode/qrCodeScan.dart';

import '../../../service/storage_service.dart';
import '../NextLesson/nextLession.dart';
import '../NextTutoring/nextTutoring.dart';

class ClassCard extends StatelessWidget {
  final String? id;
  final String? title;
  final String? tutorId;
  final String? studentId;
  final String? firstname;
  final String? lastname;
  final String? userImageURL;
  final Timestamp? date;
  final List<dynamic>? timeslot;
  final bool? tutor;
  final bool? lessonPage;
  const ClassCard(
      {super.key,
      this.tutorId,
      this.studentId,
      required this.id,
      required this.title,
      required this.firstname,
      required this.lastname,
      required this.userImageURL,
      required this.date,
      required this.timeslot,
      required this.tutor,
      required this.lessonPage});

  Future<void> _showMyDialog(BuildContext context) async {
    final currUser = FirebaseAuth.instance.currentUser!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: Text('Would you like to delete this lesson?'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection("scheduled")
                    .doc(id)
                    .delete();
                final docChat =
                    FirebaseFirestore.instance.collection('notification');
                await docChat.add({}).then((DocumentReference doc) {
                  var notif = Notifications(
                    id: doc.id,
                    from_id: currUser.uid,
                    to_id: (currUser.uid == studentId) ? tutorId : studentId,
                    type: "response",
                    content:
                        " deleted the ${(tutor!) ? "tutoring" : "lesson"} on ${DateFormat.yMd().format(date!.toDate())}",
                    view: false,
                    time: Timestamp.now(),
                  );
                  final json = notif.toFirestore();
                  docChat.doc(doc.id).update(json);
                });

                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    return Container(
      width: w > h ? 330 : 350,
      height: 200,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(children: [
            SizedBox(
              height: 70,
              width: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: FutureBuilder(
                    future: storage.downloadURL(userImageURL!),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong!");
                      } else if (snapshot.hasData) {
                        return Image(
                          image: NetworkImage(snapshot.data!),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
                child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 233, 64, 87),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _showMyDialog(context);
                      },
                      icon: const Icon(Icons.delete,
                          color: Color.fromARGB(255, 233, 64, 87), size: 20)),
                  IconButton(
                      onPressed: () {
                        if (tutor!) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QrCodeGenerate(
                                        id: id,
                                        studentId: studentId!,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QrCodeScan(
                                        id: id,
                                        tutorId: tutorId,
                                      )));
                        }
                      },
                      icon: const Icon(Icons.qr_code,
                          color: Color.fromARGB(255, 233, 64, 87), size: 20)),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  Text(
                    (tutor!) ? "Student:  " : "Tutor:  ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text("$firstname $lastname"),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Date:   ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(DateFormat.yMd().format(date!.toDate())),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                height: 40,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 0.3,
                            mainAxisSpacing: 2),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: timeslot!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color.fromARGB(255, 233, 64, 87),
                                width: 1)),
                        child: Center(
                          child: Text(
                            timeslot![index],
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ]))
          ]),
          (lessonPage != null && lessonPage == false)
              ? Container(
                  height: 35,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          tutor! == false
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NextLession()))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NextTutoring()));
                        },
                        child: const Text(
                          "see next...",
                          textAlign: TextAlign.right,
                        )),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
