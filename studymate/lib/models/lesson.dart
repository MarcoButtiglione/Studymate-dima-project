import 'package:studymate/models/category.dart';
import 'package:studymate/models/user.dart';

class Lesson {
  final String lessonName;
  final String location;
  final String date;
  final String startingTime;
  final String endingTime;
  final String description;
  final int userRating;

  final User userTutor;
  final Category category;

  Lesson(
    this.lessonName,
    this.location,
    this.date,
    this.startingTime,
    this.endingTime,
    this.description,
    this.userRating,
    this.userTutor,
    this.category,
  );
  
}
