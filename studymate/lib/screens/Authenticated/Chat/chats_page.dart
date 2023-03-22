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
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                      if (chat.isNotEmpty) {
                        return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: chat.map(buildChat).toList());
                      } else {
                        return SizedBox();
                      }
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
            if (chat.last_msg != null && !chat.delete!.contains(user.uid)) {
              return InkWell(
                  onTap: () => openChat(chat, users.first),
                  child: (user.uid == chat.from_uid)
                      ? ContactCard(
                          id: chat.id,
                          firstname: users.first.firstname,
                          lastname: users.first.lastname,
                          userImageURL: users.first.profileImageURL,
                          last_msg: chat.last_msg,
                          last_time: chat.last_time,
                          view: chat.view)
                      : ContactCard(
                          id: chat.id,
                          firstname: users.first.firstname,
                          lastname: users.first.lastname,
                          userImageURL: users.first.profileImageURL,
                          last_msg: chat.last_msg,
                          last_time: chat.last_time,
                          msg_num: chat.num_msg,
                        ));
            } else {
              return SizedBox();
            }
          } else {
            return SizedBox();
          }
        });
  }

  Future openChat(Chat chat, Users reciver) async {
    Center(child: CircularProgressIndicator());
    try {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatMsg(
                    chat: chat,
                    reciver: reciver,
                  )));
    } on Exception catch (e) {
      print(e);
    }
  }
}
