import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:studymate/component/utils.dart';

class Storage {
  final storage = FirebaseStorage.instance;
  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref().child("profilePicture").child(fileName).putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> downloadFile(String imageName) async {
    try {
      var urlRef = storage
          .ref()
          .child("profilePicture")
          .child('${imageName.toLowerCase()}.png');
      var imgUrl = await urlRef.getDownloadURL();
      return imgUrl;
    } catch (e) {
      print(e);
    }
    return "asset/";
  }
}
