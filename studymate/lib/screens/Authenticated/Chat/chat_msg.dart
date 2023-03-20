import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/message_format.dart';
import 'package:studymate/models/user.dart';
import 'package:studymate/screens/Authenticated/Chat/chats_page.dart';
import 'package:studymate/screens/Authenticated/Chat/widget/recivied_message.dart';
import 'package:studymate/screens/Authenticated/Chat/widget/sent_message.dart';

import '../../../component/utils.dart';
import '../../../models/msg.dart';

class ChatMsg extends StatefulWidget {
  final String chatId;
  final Users reciver;
  const ChatMsg({super.key, required this.chatId, required this.reciver});
  @override
  _MsgState createState() => _MsgState();
}

class _MsgState extends State<ChatMsg> {
  final user = FirebaseAuth.instance.currentUser!;
  final contentController = TextEditingController();
  var message;
  ScrollController _scrollController = ScrollController();
  _scrollToEnd() async {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  Stream<List<Msg>> msgs(String chatId) => FirebaseFirestore.instance
      .collection('msg')
      .where('chatId', isEqualTo: chatId)
      .orderBy('addtime', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Msg.fromFirestore(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(top: 50.0, bottom: 10),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChatsPage())),
                      icon: const Icon(Icons.arrow_back_ios)),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.reciver.profileImageURL),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "${widget.reciver.firstname}\n${widget.reciver.lastname}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder<List<Msg>>(
                    stream: msgs(widget.chatId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong!');
                      } else if (snapshot.hasData) {
                        message = snapshot.data!;
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
                      send();
                      if (message == null) {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
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
                    "${list.first.addtime!.toDate().day}/${list.first.addtime!.toDate().month}/${list.first.addtime!.toDate().year}",
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
    if (contentController.text.isNotEmpty) {
      try {
        String docId = "";
        final docUser = FirebaseFirestore.instance.collection('msg');
        await docUser.add({}).then((DocumentReference doc) {
          docId = doc.id;
        });
        final addMsg = Msg(
            id: docId,
            view: false,
            chatId: widget.chatId,
            addtime: Timestamp.now(),
            from_uid: user.uid,
            to_uid: widget.reciver.id,
            content: contentController.text);
        final json = addMsg.toFirestore();
        await docUser.doc(docId).set(json);
        contentController.clear();
      } on FirebaseAuthException catch (e) {
        Utils.showSnackBar(e.message);
        Navigator.of(context).pop();
      }
    }
  }
}
