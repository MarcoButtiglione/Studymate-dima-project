import 'package:cloud_firestore/cloud_firestore.dart';

class Msg {
  final String id;
  final String chatId;
  final String? from_uid;
  final String? to_uid;
  final String? content;
  final Timestamp? addtime;
  final bool view;

  Msg({
    required this.id,
    required this.chatId,
    this.from_uid,
    this.to_uid,
    this.content,
    this.addtime,
    this.view = false,
  });

  factory Msg.fromFirestore(Map<String, dynamic> json) {
    return Msg(
        id: json['id'],
        chatId: json['chatId'],
        from_uid: json['from_uid'],
        to_uid: json['to_uid'],
        content: json['content'],
        addtime: json['addtime'],
        view: json['view']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      "chatId": chatId,
      if (from_uid != null) "from_uid": from_uid,
      if (to_uid != null) "to_uid": to_uid,
      if (content != null) "content": content,
      if (addtime != null) "addtime": addtime,
      "view": view,
    };
  }
}
