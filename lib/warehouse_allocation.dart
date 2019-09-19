import 'package:flutter/material.dart';

class WarehouseAllocation extends StatelessWidget {
  final String title = 'Warehouse Allocation';
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