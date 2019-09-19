import 'package:flutter/material.dart';

class ProductSearch extends StatelessWidget {
  final String title = 'Search Product';
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