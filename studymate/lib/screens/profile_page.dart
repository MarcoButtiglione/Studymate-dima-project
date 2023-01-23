import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Profile details", style: TextStyle(fontSize: 35)),
              const SizedBox(height: 50),
              SizedBox(
                height: 150,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: const Image(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80'),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      enabled: false,
                      initialValue: 'Daniel',
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                      ),
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue: 'Rogers',
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              Row(children: const <Widget>[
                Text("Modify your interests",
                    textAlign: TextAlign.left, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
