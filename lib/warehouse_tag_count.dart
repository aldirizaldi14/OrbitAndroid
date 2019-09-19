import 'package:flutter/material.dart';

class WarehosueTagCount extends StatelessWidget {
  final String title = 'Warehouse Tag Count';
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