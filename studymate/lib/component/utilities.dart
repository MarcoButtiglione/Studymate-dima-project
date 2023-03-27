

import 'package:flutter/material.dart';


enum ScreenSize { Desktop, Tablet, Smartphone, Watch }

class Utilities {
  //this method is used to check if location service/permission are all ok
  //this method is used to show a alert with just one button
  showAlertDialog(BuildContext context, String title, String msg) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
