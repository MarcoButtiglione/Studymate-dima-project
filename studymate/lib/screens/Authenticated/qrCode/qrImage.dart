import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRImage extends StatelessWidget {
  const QRImage(this.controller,
      {super.key,
      required this.tutorId,
      required this.studentId,
      required this.id});

  final List<String> controller;
  final String tutorId;
  final String studentId;
  final String? id;

  @override
  Widget build(BuildContext context) {
    String data = "";
    if (controller.isNotEmpty) {
      print(controller);

      data =
          '{"id":"$id","studentId":"$studentId", "tutorId":"$tutorId","timeslot": [';
      controller.forEach(
        (element) {
          data += '" $element ,"';
        },
      );
      data += "]}";
      print(data);
    }
    return Center(
      child: (data != "")
          ? QrImage(
              data: data,
              size: 280,
              // You can include embeddedImageStyle Property if you
              //wanna embed an image from your Asset folder
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(
                  100,
                  100,
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
