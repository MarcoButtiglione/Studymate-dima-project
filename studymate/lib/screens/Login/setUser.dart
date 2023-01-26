import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../component/utils.dart';

class SetUser extends StatefulWidget {
  @override
  _SetUserState createState() => _SetUserState();
}

class _SetUserState extends State<SetUser> {
  final firstnameControler = TextEditingController();
  final lastnameControler = TextEditingController();
  //final imageControler = TextEditingController();

  @override
  void dispose() {
    firstnameControler.dispose();
    lastnameControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Welcome",
            style: TextStyle(
              fontFamily: "Crimson Pro",
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Color.fromARGB(255, 233, 64, 87),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              SizedBox(
                height: 150,
                width: 150,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset("assets/login/google.png")),
              ),
              IconButton(
                  icon: const Icon(Icons.photo_camera),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FlutterLogo(size: 120),
                            const FlutterLogo(size: 120),
                            const FlutterLogo(size: 120),
                            ElevatedButton(
                              child: const Text("Close"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  style: IconButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    disabledBackgroundColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    hoverColor: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.08),
                    focusColor: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.12),
                    highlightColor: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.12),
                  )),
            ],
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              controller: firstnameControler,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Name"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => email != null ? 'Enter a name' : null,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              controller: firstnameControler,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Surname"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => email != null ? 'Enter a surname' : null,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40.0),
            width: 300,
            child: ElevatedButton(
                onPressed: Continue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 233, 64, 87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  padding: (size.width <= 550)
                      ? const EdgeInsets.symmetric(horizontal: 70, vertical: 20)
                      : const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 25),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                )),
          ),
        ]));
  }

  Future Continue() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
//      Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => ,,()));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
