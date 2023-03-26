import 'package:studymate/models/category.dart';
import 'package:studymate/models/user.dart';

class TimeslotsWeek {
  final String userId;
  Map<String,List<Map<String,dynamic>>> week ;
  

  TimeslotsWeek({
    required this.userId,
    required this.week,
  });
  
  static TimeslotsWeek fromJson(Map<String, dynamic> json) => TimeslotsWeek(
        userId: json['userId'],
        week: json['week'],
       
      );

  Map<String, dynamic> toFirestore() {
    var map ={
      "userId": userId,
      "week": week,
    };
    return map;
  }
}

