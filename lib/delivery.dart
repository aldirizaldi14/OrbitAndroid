import 'package:flutter/material.dart';

class Delivery extends StatelessWidget {
  final String title = 'Delivery';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text('Available Soon'),
        )
    );
  }
}