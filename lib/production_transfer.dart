import 'package:flutter/material.dart';

class ProductionTransfer extends StatelessWidget {
  final String title = 'Production Transfer';
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