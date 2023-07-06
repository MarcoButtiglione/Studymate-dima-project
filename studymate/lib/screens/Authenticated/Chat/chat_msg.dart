import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studymate/models/user.dart';
import 'package:studymate/screens/Authenticated/Chat/widget/recivied_message.dart';
import 'package:studymate/screens/Authenticated/Chat/widget/sent_message.dart';

import '../../../component/utils.dart';
import '../../../models/chat.dart';
import '../../../models/msg.dart';
import '../../../models/notification.dart';
import '../../../service/storage_service.dart';

class ChatMsg extends StatefulWidget {
  final Chat? chat;
  final Users reciver;
  const ChatMsg({super.key, this.chat, required this.reciver});
  @override
  _MsgState createState() => _MsgState();
}

class _MsgState extends State<ChatMsg> {
  late int? num = widget.chat!.num_msg;
  final user = FirebaseAuth.instance.currentUser!;
  final contentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  _scrollToEnd() async {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  Stream<List<Msg>> msgs() => FirebaseFirestore.instance
      .collection('msg')
      .where('chatId', isEqualTo: widget.chat!.id)
      .orderBy('addtime', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Msg.fromFirestore(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return Scaffold(
        body: Container(
      color: const Color.fromARGB(18, 233, 64, 87),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.only(top: 60.0, bottom: 10),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: FutureBuilder(
                          future: storage
                              .downloadURL(widget.reciver.profileImageURL),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text("Something went wrong!");
                            } else if (snapshot.hasData) {
                              return Image(
                                image: NetworkImage(snapshot.data!),
                              );
                            } else {
                              return Card(
                                margin: EdgeInsets.zero,
                              );
                            }
                          }),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      (widget.reciver.firstname.length +
                                  widget.reciver.lastname.length <
                              15)
                          ? "${widget.reciver.firstname} ${widget.reciver.lastname}"
                          : "${widget.reciver.firstname} \n${widget.reciver.lastname}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder<List<Msg>>(
                    stream: msgs(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong!');
                      } else if (snapshot.hasData) {
                        var message = snapshot.data!;
                        if (message.isEmpty) {
                          return SizedBox();
                        } else {
                          return buildMessage(message);
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10, left: 10),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: contentController,
                      onTap: _scrollToEnd,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 3,
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (contentController.text != "") {
                        send();
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                      }
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10, right: 10),
                      child: const Icon(
                        Icons.send,
                        color: Color.fromARGB(255, 233, 64, 87),
                        size: 30,
                      ),
                    ))
              ],
            )
          ]),
    ));
  }

  List<List<Msg>> groupByDate(List<Msg> msgs) {
    Timestamp? d = msgs.first.addtime;

    List<Msg> temp = [];
    List<List<Msg>> grouped = [];
    msgs.forEach((element) {
      if (element.addtime!.toDate().day == d!.toDate().day &&
          element.addtime!.toDate().month == d!.toDate().month &&
          element.addtime!.toDate().year == d!.toDate().year) {
        temp.add(element);
        if (element.id == msgs.last.id) {
          grouped.add(temp);
        }
      } else {
        grouped.add(temp);
        temp = [];
        d = element.addtime;
        if (element.addtime!.toDate().day == d!.toDate().day &&
            element.addtime!.toDate().month == d!.toDate().month &&
            element.addtime!.toDate().year == d!.toDate().year) {
          temp.add(element);
          if (element.id == msgs.last.id) {
            grouped.add(temp);
          }
        }
      }
    });
    return grouped;
  }

  Widget buildMessage(List<Msg> message) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());

    List<List<Msg>>? grouped = groupByDate(message);
    grouped = grouped.reversed.toList();
    return Container(
      child: ListView.builder(
        //reverse: true,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: grouped.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          List<Msg> list = grouped![index].reversed.toList();
          return Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 20, right: 20),
                  child: Text(
                    DateFormat.yMd().format(list.first.addtime!.toDate()),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 144, 0, 0),
                    ),
                  )),
              Column(
                children: list.map(displayMessage).toList(),
              )
            ],
          );
        },
      ),
    );
  }

  Widget displayMessage(Msg message) {
    if (message.from_uid == user.uid) {
      return SentMessage(
        message: message.content,
        addTime: message.addtime,
        view: message.view,
      );
    } else {
      if (message.view == false) {
        try {
          FirebaseFirestore.instance
              .collection('msg')
              .doc(message.id)
              .update({'view': true});
          num = 0;
          FirebaseFirestore.instance
              .collection('chat')
              .doc(widget.chat!.id)
              .update({'num_msg': 0, 'view': true});
        } catch (e) {
          print(e);
        }
      }
      return ReciviedMessage(
        message: message.content,
        addTime: message.addtime,
      );
    }
  }

  Future send() async {
    try {
      String docId = "";
      final docUser = FirebaseFirestore.instance.collection('msg');
      final addMsg = Msg(
          view: false,
          chatId: widget.chat!.id,
          addtime: Timestamp.now(),
          from_uid: user.uid,
          //to_uid: widget.reciver.id,
          content: contentController.text);
      final json = addMsg.toFirestore();
      await docUser.add(json).then((DocumentReference doc) {
        docId = doc.id;
      });
      docUser.doc(docId).update({'id': docId});
      contentController.clear();
      num = num! + 1;
      FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.chat!.id)
          .update({
        'num_msg': num,
        'last_msg': addMsg.content,
        'last_time': addMsg.addtime,
        'from_uid': addMsg.from_uid,
        'view': false
      });
      final docChat = FirebaseFirestore.instance.collection('notification');
      await docChat.add({}).then((DocumentReference doc) {
        var notif = Notifications(
          id: doc.id,
          from_id: addMsg.from_uid,
          to_id: widget.reciver.id,
          eventId: addMsg.id,
          type: "message",
          content: "${addMsg.content}",
          view: false,
          time: Timestamp.now(),
        );
        final json = notif.toFirestore();
        docChat.doc(doc.id).update(json);
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
