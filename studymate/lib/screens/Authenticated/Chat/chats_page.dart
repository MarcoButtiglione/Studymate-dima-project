import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/models/msg.dart';
import 'package:studymate/models/user.dart';
import 'package:studymate/screens/Authenticated/Chat/chat_msg.dart';
import 'package:studymate/screens/Authenticated/authenticated.dart';
import 'package:studymate/screens/Authenticated/Chat/widget/contact_card.dart';
import '../../../models/chat.dart';
import 'widget/autocomplete_searchbar.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  Stream<List<Chat>> readChat() => FirebaseFirestore.instance
      .collection('chat')
      .where('member', arrayContains: user.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Chat.fromFirestore(doc.data())).toList());

  Stream<List<Users>> readUser(String userId) => FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());

  Stream<List<Msg>> lastMsg(String chatId) => FirebaseFirestore.instance
      .collection('msg')
      .where('chatId', isEqualTo: chatId)
      .orderBy('addtime', descending: true)
      .limit(11)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Msg.fromFirestore(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
        body: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(children: <Widget>[
                IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authenticated())),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    )),
                const Expanded(
                    child: Text("Messages",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ))),
              ]),
              const SizedBox(height: 10),
              AutocompleteSearchbar(),
              StreamBuilder<List<Chat>>(
                  stream: readChat(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong!');
                    } else if (snapshot.hasData) {
                      final chat = snapshot.data!;
                      return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: chat.map(buildChat).toList());
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          )),
    ));
  }

  Widget buildChat(Chat chat) {
    String userId = "";
    chat.member!.forEach((element) {
      if (element != user.uid) userId = element;
    });
    return StreamBuilder<List<Users>>(
        stream: readUser(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong!');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return StreamBuilder(
                stream: lastMsg(chat.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong!');
                  } else if (snapshot.hasData) {
                    final msg = snapshot.data!;
                    if (msg.isEmpty) {
                      return SizedBox();
                    }
                    if (msg.first.from_uid == user.uid) {
                      return InkWell(
                          onTap: () => openChat(chat.id, 0, users.first),
                          child: ContactCard(
                              id: chat.id,
                              firstname: users.first.firstname,
                              lastname: users.first.lastname,
                              userImageURL: users.first.profileImageURL,
                              last_msg: msg.first.content,
                              last_time: msg.first.addtime,
                              view: msg.first.view));
                    } else {
                      int num = 0;
                      msg.forEach((element) {
                        if (element.view == false) {
                          num++;
                        }
                      });
                      return InkWell(
                          onTap: () => openChat(chat.id, num, users.first),
                          child: ContactCard(
                              id: chat.id,
                              firstname: users.first.firstname,
                              lastname: users.first.lastname,
                              userImageURL: users.first.profileImageURL,
                              last_msg: msg.first.content,
                              last_time: msg.first.addtime,
                              msg_num: num));
                    }
                  } else {
                    return SizedBox();
                  }
                });
          } else {
            return SizedBox();
          }
        });
  }

  Future openChat(String id, num num_msg, Users reciver) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      if (num_msg > 0) {
        var col = FirebaseFirestore.instance.collection('msg');
        var msg = col
            .where('chatId', isEqualTo: id)
            .where('view', isEqualTo: false)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Msg.fromFirestore(doc.data()))
                .toList());
        msg.forEach((element) {
          col.doc(element.first.id).update({'view': true});
        });
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatMsg(
                    chatId: id,
                    reciver: reciver,
                  )));
    } on Exception catch (e) {
      print(e);
    }
  }
}
