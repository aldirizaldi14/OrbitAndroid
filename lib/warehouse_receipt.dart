import 'package:flutter/material.dart';

class WarehouseReceipt extends StatelessWidget {
  final String title = 'Warehouse Receipt';
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