import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/category.dart';
import '../../../../models/lesson.dart';
import '../../../../service/storage_service.dart';

class OwnLessonsProfilePage extends StatefulWidget {
  @override
  State<OwnLessonsProfilePage> createState() => _OwnLessonsProfilePageState();
}

class _OwnLessonsProfilePageState extends State<OwnLessonsProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final Storage storage = Storage();

  Stream<List<Lesson>> readOwnLessons(String userId) =>
      FirebaseFirestore.instance
          .collection('lessons')
          .where('userTutor', isEqualTo: userId)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Lesson.fromJson(doc.data())).toList());
  Stream<List<Category>> readCategory(String category) => FirebaseFirestore
      .instance
      .collection('categories')
      .where('name', isEqualTo: category)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Lesson>>(
        stream: readOwnLessons(user.uid),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong!");
          } else if (snapshot.hasData) {
            final lessons = snapshot.data!;
            return Column(
              children: lessons
                  .map(
                    (lesson) => ListTile(
                      //titleAlignment: titleAlignment,
                      leading: StreamBuilder<List<Category>>(
                          stream: readCategory(lesson.category),
                          builder: ((context, snapshot) {
                            if (snapshot.hasError) {
                              return const CircleAvatar(
                                child: Text('E'),
                              );
                            } else if (snapshot.hasData) {
                              final category = snapshot.data!.first;
                              return FutureBuilder(
                                  future: storage
                                      .downloadURL(category.imageURL),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const CircleAvatar(
                                        child: Text('E'),
                                      );
                                    } else if (snapshot.hasData) {
                                      return CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(snapshot.data!),
                                      );
                                    } else {
                                      return const CircleAvatar();
                                    }
                                  });
                            } else {
                              return const CircleAvatar();
                            }
                          })),
                      title: Text(
                        lesson.title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      trailing: PopupMenuButton<ListTileTitleAlignment>(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<ListTileTitleAlignment>>[
                          const PopupMenuItem<ListTileTitleAlignment>(
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 16),
                                Text('Edit lesson'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<ListTileTitleAlignment>(
                            child: Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 16),
                                Text('Remove lesson'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }
}
