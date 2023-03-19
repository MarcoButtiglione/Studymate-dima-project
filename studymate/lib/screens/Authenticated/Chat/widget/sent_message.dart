import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'custom_shape.dart';

class SentMessage extends StatelessWidget {
  final String? message;
  final Timestamp? addTime;
  final bool? view;
  const SentMessage({super.key, this.message, this.addTime, this.view});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18.0, left: 50, top: 15, bottom: 5),
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
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 233, 64, 87),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message!,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text:
                              "${addTime!.toDate().hour}:${addTime!.toDate().minute}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                      const WidgetSpan(
                        child: SizedBox(
                          width: 5,
                        ),
                      ),
                      WidgetSpan(
                          child: (view == true)
                              ? const Icon(
                                  Icons.done_all,
                                  color: Colors.indigo,
                                  size: 20,
                                )
                              : const Icon(
                                  Icons.done_all,
                                  color: Colors.white,
                                  size: 20,
                                ))
                    ])),
                  ],
                )),
          ),
          CustomPaint(
              painter: CustomShape(const Color.fromARGB(255, 233, 64, 87))),
        ],
      ));
}
