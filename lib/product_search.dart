import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unified_process/model/product_model.dart';
import 'helper/database_helper.dart';
import 'dart:developer';

class ProductSearch extends StatefulWidget {
  ProductSearch({ Key key}) : super (key: key);
  final String title = 'Product Search';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductSearchState createState() => ProductSearchState();
}

class ProductSearchState extends State<ProductSearch> {
  String productCode = '';
  String description = '';
  List<TableRow> productData = [];

  Future<void> initPlatformState() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      productCode = barcodeScanRes;
      description = 'Description of ' + productCode;
    });
  }

  void fetchData() async {
    final allRows = await widget.databaseHelper.queryAllRows('product');

    List<TableRow> test = [];
    int i = 0;
    allRows.forEach((row){
      ++i;
      print(row);
      print(i);
      ProductModel rowData = ProductModel.fromDb(row);
      test.add(TableRow(
          children: [
            Text(i.toString()),
            Text(rowData.product_code),
            Text(rowData.product_description),
            Text(rowData.product_description),
          ]
      ));
    });
    setState(() {
      productData = test;
    });
  }

  void testinsert() async{
    ProductModel productModel = ProductModel();
    productModel = ProductModel.random();
    int test = await widget.databaseHelper.insert(productModel.tableName, productModel.toMap());
    print(test);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            testinsert();
          },
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  child: Icon(FontAwesomeIcons.barcode, color: Colors.white,),
                  onPressed: (){
                    setState(() {
                      productCode = 'E123A';
                      description = 'Description of ' + productCode;
                    });
                    fetchData();
                  },
                ),
              ),
              Text(productCode, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Text(description, style: TextStyle(fontSize: 12),),
              Table(
                border: TableBorder.all(color: Colors.black),
                columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.2), 3: FractionColumnWidth(.2)},
                children: [
                  TableRow(
                      children: [
                        Text('#'),
                        Text('Warehouse'),
                        Text('Pallet'),
                        Text('Qty'),
                      ]
                  ),
               ]
            ),
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.2), 3: FractionColumnWidth(.2)},
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