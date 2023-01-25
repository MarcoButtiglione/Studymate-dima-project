import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtherProfilePage extends StatelessWidget {
  const OtherProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Daniel Rogers'),
      ),
    );
  }
}