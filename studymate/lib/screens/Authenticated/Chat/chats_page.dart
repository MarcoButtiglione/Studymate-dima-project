import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/models/user.dart';
import 'package:studymate/screens/Authenticated/Chat/chat_msg.dart';
import 'package:studymate/screens/Authenticated/Chat/widget/contact_card.dart';
import '../../../models/chat.dart';
import 'widget/autocomplete_searchbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  late String selected = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  CollectionReference _notRef =
      FirebaseFirestore.instance.collection('notification');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _notRef
        .where('to_id', isEqualTo: user.uid)
        .where('type', isEqualTo: "message")
        .get();

    final allData = querySnapshot.docs.map((doc) {
      return doc.get("id");
    }).toList();
    allData.forEach((element) {
      FirebaseFirestore.instance
          .collection("notification")
          .doc(element)
          .delete();
    });
  }

  Stream<List<Users>> readUser(String userId) => FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: userId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());

  Stream<List<Chat>> readChat() => FirebaseFirestore.instance
      .collection('chat')
      .where('member', arrayContains: user.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Chat.fromFirestore(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.messages,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              AutocompleteSearchbar(onSelected: (selectedUser) {
                setState(() {
                  selected = selectedUser;
                  print(selectedUser);
                });
              }),
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
    );
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
            //String firstname = "", lastname = "";
            if (chat.last_msg != "") {
              if (selected != "") {
                if ("${users.first.firstname.toLowerCase()} ${users.first.lastname.toLowerCase()}" ==
                    selected.toLowerCase()) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                          onTap: () => openChat(chat, users.first),
                          child: user.uid == chat.from_uid
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
                                )),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              } else {
                return Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                        onTap: () => openChat(chat, users.first),
                        child: user.uid == chat.from_uid
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
                              )),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(),
                  ],
                );
              }
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
