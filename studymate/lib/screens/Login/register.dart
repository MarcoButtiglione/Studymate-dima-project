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
    double h = size.height;
    double w = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Register",
                      style: TextStyle(
                        fontFamily: "Crimson Pro",
                        fontWeight: FontWeight.bold,
                        fontSize: (w > 490 && h > 720) ? 60 : 35,
                        color: Color.fromARGB(255, 233, 64, 87),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      width: 0.8 * w,
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                              fontSize: (w > 490 && h > 720) ? 25 : 14),
                          hintStyle: TextStyle(
                              fontSize: (w > 490 && h > 720) ? 16 : 12),
                          errorStyle: TextStyle(
                              fontSize: (w > 490 && h > 720) ? 16 : 12),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                        style:
                            TextStyle(fontSize: (w > 490 && h > 720) ? 25 : 14),
                      ),
                    ),
                    //SizedBox(height: size.height * 0.03),
                    Container(
                      width: 0.8 * w,
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              fontSize: (w > 490 && h > 720) ? 25 : 14),
                          hintStyle: TextStyle(
                              fontSize: (w > 490 && h > 720) ? 16 : 12),
                          errorStyle: TextStyle(
                              fontSize: (w > 490 && h > 720) ? 16 : 12),
                        ),
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Enter min. 6 characters'
                            : null,
                        style:
                            TextStyle(fontSize: (w > 490 && h > 720) ? 25 : 14),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 0.03 * h, left: 0.03 * h, right: 0.03 * h),
                      height: 0.08 * h,
                      width: 0.8 * w,
                      child: ElevatedButton(
                          onPressed: signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 233, 64, 87),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (w > 490 && h > 720) ? 30 : 16,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: (w > 490 && h > 720) ? 20 : 12,
                                  color: Color.fromARGB(156, 65, 62, 88)),
                              text: "Already Have an Account?",
                              children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login())),
                              text: ' Login',
                              style: TextStyle(
                                  fontSize: (w > 490 && h > 720) ? 20 : 12,
                                  color: Color.fromARGB(255, 233, 64, 87)),
                            )
                          ])),
                    ),
                  ]),
            ],
          ),
        ),
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
