import 'package:firebase_auth/firebase_auth.dart';
import 'package:studymate/models/category.dart';

class Users {
  final String firstname;
  final String lastname;
  late String profileImageURL;
  late List<String> categoriesOfInterest;
  final int userRating;

  Users({
    required this.firstname,
    required this.lastname,
    required this.profileImageURL,
    required this.userRating,
  });

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'profileImage': profileImageURL,
        'userRating': userRating,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        firstname: json['firstname'],
        lastname: json['lastname'],
        profileImageURL: json['profileImageURL'],
        userRating: json['userRating'],
      );
}
