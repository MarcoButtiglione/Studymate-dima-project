import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../lesson_page.dart';

class ContactCard extends StatelessWidget {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? userImageURL;
  final String? last_msg;
  final Timestamp? last_time;
  final int? msg_num;
  final bool? view;
  const ContactCard(
      {super.key,
      required this.id,
      required this.firstname,
      required this.lastname,
      required this.userImageURL,
      required this.last_msg,
      required this.last_time,
      this.msg_num,
      this.view});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(userImageURL!),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "$firstname $lastname",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          last_time!.toDate().month <
                                      Timestamp.now().toDate().month ||
                                  last_time!.toDate().day <
                                      Timestamp.now().toDate().day
                              ? DateFormat.yMd().format(last_time!.toDate())
                              : DateFormat.Hm().format(last_time!.toDate()),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 47, 47, 47))),
                    ],
                  ),
                  Row(
                    children: [
                      (view != null)
                          ? ((view == true)
                              ? const Icon(
                                  Icons.done_all,
                                  color: Colors.indigo,
                                  size: 20,
                                )
                              : const Icon(
                                  Icons.done_all,
                                  color: Color.fromARGB(255, 47, 47, 47),
                                  size: 20,
                                ))
                          : const SizedBox(),
                      Expanded(
                          child: Text(
                              " ${last_msg!.length < 70 ? last_msg : "${last_msg!.substring(0, 67)}..."}")),
                      (msg_num! > 0)
                          ? SizedBox(
                              height: 25,
                              width: 25,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Container(
                                  color: Color.fromARGB(255, 233, 64, 87),
                                  child: Center(
                                    child: Text(
                                      (msg_num! <= 10)
                                          ? msg_num.toString()
                                          : "+10",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.grey,
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
