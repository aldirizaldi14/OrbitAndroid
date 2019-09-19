import 'package:flutter/material.dart';
import 'login.dart';
import 'menu.dart';
import 'product_search.dart';
import 'production_output.dart';
import 'production_transfer.dart';
import 'warehouse_receipt.dart';
import 'warehouse_allocation.dart';
import 'warehouse_tag_count.dart';
import 'delivery.dart';
import 'task.dart';
import 'setting.dart';
import 'package:unified_process/About.dart';

void main(){
  runApp(
    MaterialApp(
      title: '',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginClass(),
        '/menu': (context) => MenuClass(),
        '/product_search': (context) => ProductSearch(),
        '/production_output': (context) => ProductionOutputClass(),
        '/production_transfer': (context) => ProductionTransfer(),
        '/warehouse_receipt': (context) => WarehouseReceipt(),
        '/warehouse_allocation': (context) => WarehouseAllocation(),
        '/warehouse_tag_count': (context) => WarehosueTagCount(),
        '/delivery': (context) => Delivery(),
        '/task': (context) => Delivery(),
        '/delivery': (context) => Delivery(),
        '/task': (context) => Task(),
        '/setting': (context) => Setting(),
        '/about': (context) => About(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      )
    )
  );
}