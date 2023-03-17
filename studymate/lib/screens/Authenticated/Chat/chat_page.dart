import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/models/msg.dart';
import 'package:studymate/models/user.dart';
import 'package:studymate/screens/Authenticated/common_widgets/contact_card.dart';
import '../../../models/chat.dart';
import '../Chat/autocomplete_searchbar.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatPage> {
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
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(children: const <Widget>[
                    Expanded(
                      flex: 9,
                      child: Text("Messages",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ]),
                  AutocompleteSearchbar(),
                  const SizedBox(height: 10),
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
                    if (msg.first.from_uid == user.uid) {
                      print(msg.first.addtime!.toDate().toString());
                      return InkWell(
                          onTap: () => openChat(chat.id, false),
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
                          onTap: () => openChat(chat.id, true),
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
                    return Center(child: CircularProgressIndicator());
                  }
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future openChat(String id, bool view) async {
    if (view == true) {
      try {
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
      } on Exception catch (e) {
        print(e);
      }
    } else {}
  }
}
