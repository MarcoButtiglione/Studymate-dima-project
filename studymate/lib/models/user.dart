import 'package:firebase_auth/firebase_auth.dart';
import 'package:studymate/models/category.dart';

class Users {
  String id;
  final String firstname;
  final String lastname;
  final String profileImageURL;
  final List<dynamic>? categoriesOfInterest;
  final int userRating;

  Users({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.profileImageURL,
    required this.userRating,
    this.categoriesOfInterest,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'profileImage': profileImageURL,
        'userRating': userRating,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      profileImageURL: json['profileImage'],
      userRating: json['userRating'],
      categoriesOfInterest: json['categoriesOfInterest']);
}
