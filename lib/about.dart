import 'package:flutter/material.dart';

class About extends StatelessWidget {
  final String title = 'About';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(title),
        )
    );
  }
}