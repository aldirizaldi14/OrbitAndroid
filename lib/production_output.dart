import 'package:flutter/material.dart';

class ProductionOutputClass extends StatelessWidget {
  final String title = 'Production Output';
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