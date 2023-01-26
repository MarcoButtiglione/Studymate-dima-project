import 'package:studymate/models/category.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String birthdayDate;
  final String profileImageURL;
  final List<Category> categoriesOfInterest;
  final int userRating;


  User(
    this.firstName,
    this.lastName,
    this.email,
    this.birthdayDate,
    this.profileImageURL,
    this.categoriesOfInterest,
    this.userRating,
  );
}
