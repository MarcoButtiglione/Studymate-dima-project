import 'package:studymate/models/category.dart';
import 'package:studymate/models/user.dart';

class TimeslotsWeek {
  final String userId;
  List<dynamic> monday;
  List<dynamic> tuesday ;
  List<dynamic> wednesday ;
  List<dynamic> thursday ;
  List<dynamic> friday ;
  List<dynamic> saturday ;
  List<dynamic> sunday ;

  TimeslotsWeek({
    required this.userId,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });
  
  static TimeslotsWeek fromJson(Map<String, dynamic> json) => TimeslotsWeek(
        userId: json['userId'],
        monday: json['monday'],
        tuesday: json['tuesday'],
        wednesday: json['wednesday'],
        thursday: json['thursday'],
        friday: json['friday'],
        saturday: json['saturday'],
        sunday: json['sunday'],
       
      );

  Map<String, dynamic> toFirestore() {
    var map ={
      "userId": userId,
      "monday": monday,
      "tuesday": tuesday,
      "wednesday": wednesday,
      "thursday": thursday,
      "friday": friday,
      "saturday": saturday,
      "sunday": sunday,
    };
    return map;
  }
}

class Week {

}