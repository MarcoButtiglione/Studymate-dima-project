import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studymate/screens/Authenticated/Chat/chats_page.dart';
import 'package:studymate/screens/Authenticated/homepage.dart';
import 'package:studymate/screens/Authenticated/createLesson/new_lesson_page.dart';
//import 'package:studymate/screens/Authenticated/pro_page.dart';
import 'package:studymate/screens/Authenticated/profilePage/own_profile_page.dart';
import 'package:studymate/screens/Authenticated/Search/search_page.dart';
import 'package:badges/badges.dart' as badges;

import '../../models/chat.dart';

class Authenticated extends StatefulWidget {
  @override
  State<Authenticated> createState() => _AuthenticatedState();
}

class _AuthenticatedState extends State<Authenticated> {
  var _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final user = FirebaseAuth.instance.currentUser!;

  Stream<List<Chat>> readMessages() => FirebaseFirestore.instance
      .collection('chat')
      .where('member', arrayContains: user.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Chat.fromFirestore(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = SearchPage();
        break;
      case 2:
        page = NewLessonPage();
        break;
      case 3:
        page = ChatsPage();
        break;
      case 4:
        page = OwnProfilePage();
        break;

      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: SafeArea(
            child: Container(
              //color: Theme.of(context).colorScheme.background,
              child: page,
            ),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                elevation: 10,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                //backgroundColor: Theme.of(context).bottomAppBarColor,
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 35,
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: StreamBuilder(
                        stream: readMessages(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            List<Chat> messages = snapshot.data!;
                            if (messages.isNotEmpty) {
                              int num = 0;
                              messages.forEach((element) {
                                if (element.num_msg! > 0 &&
                                    element.from_uid != user.uid) {
                                  num += 1;
                                }
                              });
                              if (num > 0) {
                                return badges.Badge(
                                  position:
                                      BadgePosition.topEnd(top: 0, end: 0),
                                  showBadge: true,
                                  child: const Icon(
                                    Icons.message,
                                  ),
                                );
                              }
                            }
                          }
                          return badges.Badge(
                            position: BadgePosition.topEnd(top: 0, end: 0),
                            showBadge: false,
                            child: const Icon(
                              Icons.message,
                            ),
                          );
                        })),
                    label: 'Pro',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Theme.of(context).colorScheme.onBackground,
                onTap: _onItemTapped,
              ),
            ),
          ));
    });
  }
}
