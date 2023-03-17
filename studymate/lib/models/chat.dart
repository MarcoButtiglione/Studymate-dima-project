import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'msg.dart';

class Chat {
  final List<dynamic>? member;
  final String id;

  Chat({
    this.member,
    required this.id,
  });

  factory Chat.fromFirestore(Map<String, dynamic> json) {
    return Chat(
      member: json['member'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (member != null) "member": member,
    };
  }
}
