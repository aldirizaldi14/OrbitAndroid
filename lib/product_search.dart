import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/area_product_qty_model.dart';
import 'package:unified_process/model/product_model.dart';
import 'helper/database_helper.dart';

class ProductSearch extends StatefulWidget {
  ProductSearch({ Key key}) : super (key: key);
  final String title = 'Search Product';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductSearchState createState() => ProductSearchState();
}

class ProductSearchState extends State<ProductSearch> {
  String productCode = '';
  String description = '';
  List<TableRow> productData = [];

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.DEFAULT);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    Database db = await widget.databaseHelper.database;
    final data = await db.query('product', where: 'product_code = ?', whereArgs: [barcodeScanRes]);
    if(data.length > 0){
      ProductModel productModel = ProductModel.fromDb(data.first);
      setState(() {
        productCode = barcodeScanRes;
        description = productModel.product_description;
      });
      fetchData(productCode);
    }else {
      setState(() {
        productCode = 'Invalid';
        description = '';
      });
    }
  }

  void fetchData(String product_code) async {
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery("SELECT warehouse_name, area_name, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area.area_warehouse_id "
        "WHERE product_code = ?", [product_code]
    );
    print(allRows);

    List<TableRow> test = [];
    int i = 0;
    allRows.forEach((row){
      ++i;
      print(row);
      print(i);
      AreaProductQtyModel rowData = AreaProductQtyModel.fromDb(row);
      test.add(TableRow(
          children: [
            Padding(padding: EdgeInsets.all(5), child: Center(child: Text(i.toString())),),
            Padding(padding: EdgeInsets.all(5), child: Text(row['warehouse_name'] ?? 'Unallocated'),),
            Padding(padding: EdgeInsets.all(5), child: Text(row['area_name'] ?? ''),),
            Padding(padding: EdgeInsets.all(5), child: Center(child: Text(row['quantity'].toString())),),
          ]
      ));
    });
    setState(() {
      productData = test;
    });
  }

  void testinsert() async{
    AreaProductQtyModel areaProductQtyModel = AreaProductQtyModel.instance;
    areaProductQtyModel = AreaProductQtyModel.random();
    int test = await widget.databaseHelper.insert(areaProductQtyModel.tableName, areaProductQtyModel.toMap());
    print(test);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                scanBarcode();
              },
            )
          ],
        ),
        /*floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            testinsert();
          },
        ),*/
        body: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Text(productCode, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Text(description, style: TextStyle(fontSize: 12),),
              Table(
                border: TableBorder.all(color: Colors.black),
                columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.3), 3: FractionColumnWidth(.2)},
                children: [
                  TableRow(
                    children: [
                      Center(child: Text('#')),
                      Center(child: Text('Warehouse')),
                      Center(child: Text('Pallet')),
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
                    children: productData
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}