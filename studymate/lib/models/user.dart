import 'package:studymate/models/category.dart';

class Users {
  String id;
  final String firstname;
  final String lastname;
  final String profileImageURL;
  late List<Category> categoriesOfInterest;
  final int userRating;

  Users({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.profileImageURL,
    this.userRating = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'profileImage': profileImageURL,
        'userRating': userRating,
      };
}
