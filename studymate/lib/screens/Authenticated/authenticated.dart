import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studymate/screens/Authenticated/homepage.dart';
import 'package:studymate/screens/Authenticated/new_lesson_page.dart';
import 'package:studymate/screens/Authenticated/pro_page.dart';
import 'package:studymate/screens/Authenticated/own_profile_page.dart';
import 'package:studymate/screens/Authenticated/search_page.dart';

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
        page = ProPage();
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
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 35,
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.star),
                    label: 'Pro',
                  ),
                  BottomNavigationBarItem(
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
