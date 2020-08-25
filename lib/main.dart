import 'package:flutter/material.dart';
import 'package:unified_process/datalist_picker.dart';
import 'package:unified_process/delivery_add.dart';
import 'package:unified_process/deliveryloading.dart';
import 'package:unified_process/menudelivery.dart';
import 'package:unified_process/production_transfer_add.dart';
import 'package:unified_process/production_transfer_detail.dart';
import 'package:unified_process/receipt_detail.dart';
import 'package:unified_process/tagcount.dart';
import 'package:unified_process/warehouse_receipt_add.dart';
import 'datalist_delivery.dart';
import 'deliverypicker.dart';
import 'login.dart';
import 'menu.dart';
import 'product_search.dart';
import 'production_output.dart';
import 'production_output_add.dart';
import 'production_transfer.dart';
import 'warehouse_receipt.dart';
import 'warehouse_allocation.dart';
import 'warehouse_tag_count.dart';
import 'delivery.dart';
import 'deliverydetail.dart';
import 'delivery309112.dart';
import 'task.dart';
import 'setting.dart';
import 'package:unified_process/about.dart';
import 'barcode.dart';

void main() {
  runApp(MaterialApp(
      title: '',
      initialRoute: '/',
      routes: {
        '/': (context) => MenuClass(),
        '/login': (context) => LoginClass(),
        '/product_search': (context) => ProductSearch(),
        '/production_output': (context) => ProductionOutputClass(),
        '/production_output_add': (context) => ProductionOutputAddClass(),
        '/production_transfer': (context) => ProductionTransferClass(),
        '/production_transfer_add': (context) => ProductionTransferAddClass(),
        '/production_transfer_detail': (context) =>
            ProductionTransferDetailClass(),
        '/warehouse_receipt': (context) => WarehouseReceiptClass(),
        '/warehouse_receipt_add': (context) => WarehouseReceiptAddClass(),
        '/warehouse_receipt_detail': (context) => ReceiptDetailClass(),
        '/warehouse_allocation': (context) => WarehouseAllocationClass(),
        '/warehouse_tag_count': (context) => WarehosueTagCount(),
        '/delivery': (context) => Delivery(),
        '/task': (context) => Delivery(),
        //'/delivery': (context) => Delivery(),
        '/delivery309112': (context) => DeliveryScanAddClass(),
        '/deliverypicker': (context) => DeliveryPickerClass(),
        '/deliveryloading': (context) => DeliveryLoadingClass(),
        '/deliverytruck': (context) => DeliveryTruckClass(),
        '/datalist_picker': (context) => DatalistPickerClass(),
        '/datalist_delivery': (context) => DatalistDeliveryClass(),
        '/menudelivery': (context) => MenuDeliveryClass(),
        '/delivery_add': (context) => DeliveryAdd(),
        '/task': (context) => Task(),
        '/setting': (context) => Setting(),
        '/about': (context) => About(),
        '/barcode': (context) => Barcode(),
        '/tagcount': (context) => TagCount(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      )));
}
