import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:studymate/component/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:studymate/provider/AuthService.dart';
import 'package:studymate/screens/Login/register.dart';
import 'package:studymate/screens/Login/reset.dart';

import '../../provider/authentication.dart';
import '../Authenticated/authenticated.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Expanded(
            flex: 8,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.2),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: "Crimson Pro",
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color.fromARGB(255, 233, 64, 87),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Email"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value != null && value.isEmpty ? 'Enter password' : null,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 50, top: 10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Reset())),
                  },
                  child: const Text(
                    "Forgot your password?",
                    style: TextStyle(
                        fontSize: 12, color: Color.fromARGB(156, 65, 62, 88)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40.0),
                width: 300,
                child: ElevatedButton(
                    onPressed: signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 233, 64, 87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      padding: (size.width <= 550)
                          ? const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 20)
                          : const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 25),
                    ),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(156, 65, 62, 88)),
                        text: "Don't Have an Account?",
                        children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register())),
                        text: ' SignUp',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 233, 64, 87)),
                      )
                    ])),
              ),
            ]),
          ),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      height: 1,
                      width: 70,
                      margin: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(156, 105, 102, 121),
                      ),
                    ),
                    const Text(
                      "or sign in with google",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(156, 105, 102, 121),
                      ),
                    ),
                    Container(
                      height: 1,
                      width: 70,
                      margin: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(156, 105, 102, 121),
                      ),
                    ),
                  ]),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()));
                      Authentication.signInWithGoogle(context: context);
                    },
                    child: Container(
                        margin: const EdgeInsets.only(top: 40.0),
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(156, 105, 102, 121),
                                spreadRadius: 2),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/login/google.png",
                              height: 32,
                              width: 32,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 26,
                                top: 8,
                                right: 58,
                                bottom: 5,
                              ),
                              child: Text(
                                "Sign Up with Google",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color.fromARGB(156, 105, 102, 121)),
                              ),
                            )
                          ],
                        )),
                  )
                ],
              )),
        ]));
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      //navigatorKey.currentState!.popUntil((route) => route.isFirst);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Authenticated()));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }

  /*googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print(e);
      //Navigator.of(context).pop();
    }
  }*/
}
