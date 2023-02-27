import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studymate/component/utils.dart';
import 'package:studymate/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:studymate/screens/Login/login.dart';

import '../Authenticated/FirstLogin/setUser.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
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
      body: Form(
        key: formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.2),
                child: const Text(
                  "Register",
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
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter min. 6 characters'
                      : null,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40.0),
                width: 300,
                child: ElevatedButton(
                    onPressed: signUp,
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
                      "SignUp",
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
                        text: "Already Have an Account?",
                        children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login())),
                        text: ' Login',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 233, 64, 87)),
                      )
                    ])),
              ),
            ]),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SetUser()));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
