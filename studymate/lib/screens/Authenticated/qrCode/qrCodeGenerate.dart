import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/screens/Authenticated/qrCode/qrImage.dart';
import '../../../models/scheduled.dart';

class QrCodeGenerate extends StatefulWidget {
  final String? id;
  final String studentId;
  const QrCodeGenerate({
    super.key,
    required this.id,
    required this.studentId,
  });

  @override
  _QrCodeGenerateState createState() => _QrCodeGenerateState();
}

class _QrCodeGenerateState extends State<QrCodeGenerate> {
  final user = FirebaseAuth.instance.currentUser!;
  List<String> selectedTimeslot = [];
  bool generate = false;

  Stream<List<Scheduled>> readScheduled() => FirebaseFirestore.instance
      .collection('scheduled')
      .where('id', isEqualTo: widget.id)
      .snapshots()
      .map(((snapshot) => snapshot.docs
          .map((doc) => Scheduled.fromFirestore(doc.data()))
          .toList()));
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Row(children: <Widget>[
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            )),
                        const Expanded(
                            child: Text("Scan QrCode",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 233, 64, 87),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ]),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            "Select the taught lesson timeslot and generate the qr code, make the student scan in to gain hours to spend on lessons in the app.",
                            style: TextStyle(
                              fontFamily: "Crimson Pro",
                              fontSize: 16,
                              color: Color.fromARGB(255, 104, 104, 104),
                            )),
                      ),
                      StreamBuilder(
                        stream: readScheduled(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var schedules = snapshot.data!;
                            List<String> up = [];
                            if (schedules.isNotEmpty) {
                              if (selectedTimeslot.isNotEmpty) {
                                selectedTimeslot.forEach((element) {
                                  if (schedules.first.timeslot!
                                      .contains(element)) {
                                    up.add(element);
                                  }
                                });
                              }

                              selectedTimeslot = up;

                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    MultiSelectChip(schedules.first.timeslot!,
                                        onSelectionChanged: (selectedList) {
                                      setState(() {
                                        selectedTimeslot = selectedList;
                                      });
                                    }),
                                    (selectedTimeslot.isNotEmpty)
                                        ? QRImage(selectedTimeslot,
                                            tutorId: user.uid,
                                            studentId: widget.studentId,
                                            id: widget.id)
                                        : SizedBox(),
                                  ],
                                ),
                              );
                            }
                          }
                          return SizedBox();
                        },
                      ),
                    ]))));
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<dynamic> timeSlotList;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(this.timeSlotList, {required this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    widget.timeSlotList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.toString()),
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
