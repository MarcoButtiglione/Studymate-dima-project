import 'package:studymate/models/category.dart';
import 'package:studymate/models/user.dart';

class Lesson {
  final String title;
  final String location;
  final String description;
  final String userTutor;
  final String category;

  Lesson({
    required this.title,
    required this.location,

    required this.description,
    required this.userTutor,
    required this.category,
  });
  static Lesson fromJson(Map<String, dynamic> json) => Lesson(
        title: json['title'],
        location: json['location'],
        description: json['description'],
        userTutor: json['userTutor'],
        category: json['category'],
      );

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "location": location,
      "description": description,
      "userTutor": userTutor,
      "category": category,
    };
  }
}
