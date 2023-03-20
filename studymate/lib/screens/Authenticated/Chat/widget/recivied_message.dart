import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'custom_shape.dart';

class ReciviedMessage extends StatelessWidget {
  final String? message;
  final Timestamp? addTime;
  const ReciviedMessage({super.key, this.message, this.addTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18.0, left: 18, top: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 30),
          messageTextGroup(),
        ],
      ),
    );
  }

  Widget messageTextGroup() => Flexible(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi),
            child: CustomPaint(
              painter: CustomShape(Color.fromARGB(255, 242, 210, 210)),
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 210, 210),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  message!,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  DateFormat.Hm().format(addTime!.toDate()),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ]),
            ),
          ),
        ],
      ));
}
