import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/area_product_qty_model.dart';
import 'package:unified_process/model/product_model.dart';
import 'helper/database_helper.dart';

class Task extends StatefulWidget {
  Task({ Key key}) : super (key: key);
  final String title = 'Remaining Task';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  TaskState createState() => TaskState();
}

class TaskState extends State<Task> {
  List<TableRow> listData = [];
  SharedPreferences _sharedPreferences;

  void fetchData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    Database db = await widget.databaseHelper.database;
    List allRows;
    if(_sharedPreferences.getInt("USER_GROUP_ID") == 1) {
      allRows = await db.rawQuery(
          "SELECT warehouse_name, area_name, product_description, quantity FROM area_product_qty "
              "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
              "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
              "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
              "WHERE (area_product_qty.warehouse_id = 1 OR area_product_qty.area_id = 0) AND quantity > 0"
      );
    }else if(_sharedPreferences.getInt("USER_GROUP_ID") == 2) {
      allRows = await db.rawQuery(
          "SELECT warehouse_name, area_name, product_description, quantity FROM area_product_qty "
              "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
              "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
              "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
              "WHERE area_product_qty.warehouse_id = 1 AND quantity > 0"
      );
    }else{
      allRows = await db.rawQuery(
          "SELECT warehouse_name, area_name, product_description, quantity FROM area_product_qty "
              "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
              "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
              "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
              "WHERE area_product_qty.area_id = 0 AND quantity > 0"
      );
    }
    print(allRows);

    List<TableRow> tableData = [];
    int i = 0;
    allRows.forEach((row){
      ++i;
      print(row);
      print(i);
      AreaProductQtyModel rowData = AreaProductQtyModel.fromDb(row);
      tableData.add(TableRow(
          children: [
            Padding(padding: EdgeInsets.all(5), child: Center(child: Text(i.toString())),),
            Padding(padding: EdgeInsets.all(5), child: Text(row['warehouse_name'] == null ? 'Unallocated' : row['warehouse_name']),),
            Padding(padding: EdgeInsets.all(5), child: Text(row['product_description']),),
            Padding(padding: EdgeInsets.all(5), child: Center(child: Text(row['quantity'].toString())),),
          ]
      ));
    });
    setState(() {
      listData = tableData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.3), 3: FractionColumnWidth(.2)},
                  children: [
                    TableRow(
                      children: [
                        Center(child: Text('#')),
                        Center(child: Text('Warehouse')),
                        Center(child: Text('Product')),
                        Center(child: Text('Qty')),
                      ],
                    ),
                  ]
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.3), 3: FractionColumnWidth(.2)},
                      children: listData
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
}