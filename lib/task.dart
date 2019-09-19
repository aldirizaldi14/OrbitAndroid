import 'package:flutter/material.dart';

class Task extends StatelessWidget {
  final String title = 'Task';
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