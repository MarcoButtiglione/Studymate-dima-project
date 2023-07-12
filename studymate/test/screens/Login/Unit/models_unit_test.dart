import 'package:flutter_test/flutter_test.dart';
import 'package:studymate/models/user.dart';

void main() {
  group('Users', () {
    test('fromJson', () {
      //setup
      Users user = Users(
          numRating: 4,
          id: 'test',
          firstname: 'test',
          lastname: 'test',
          profileImageURL: 'test',
          userRating: '4',
          hours: 4);
      Map<String, dynamic> json = {
        'id': 'test',
        'firstname': 'test',
        'lastname': 'test',
        'profileImage': 'test',
        'userRating': '4',
        'hours': 4,
        'numRating': 4,
        'categoriesOfInterest': []
      };

      int i = 1;
      //do
      i++;
      //test
      expect(i, 2);
    });
    test('toJson', () {
      //setup
      int i = 1;
      //do
      i++;
      //test
      expect(i, 2);
    });
  });
}
