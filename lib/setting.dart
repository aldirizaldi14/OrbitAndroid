import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  final String title = 'Setting';
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