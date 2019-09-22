import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/pallet_product_qty_model.dart';
import 'helper/database_helper.dart';

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

  Future<void> scanBarcode() async {
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
    fetchData(int.parse(productCode));
  }

  void fetchData(int product_id) async {
    Database db = await widget.databaseHelper.database;
    final allRows = await db.query(PalletProductQtyModel.instance.tableName, where: 'product_id = ?', whereArgs:[product_id]);

    List<TableRow> test = [];
    int i = 0;
    allRows.forEach((row){
      ++i;
      print(row);
      print(i);
      PalletProductQtyModel rowData = PalletProductQtyModel.fromDb(row);
      test.add(TableRow(
          children: [
            Text(i.toString()),
            Text(rowData.warehouse_id.toString()),
            Text(rowData.pallet_id.toString()),
            Text(rowData.product_id.toString()),
          ]
      ));
    });
    setState(() {
      productData = test;
    });
  }

  void testinsert() async{
    PalletProductQtyModel palletProductQtyModel = PalletProductQtyModel();
    palletProductQtyModel = PalletProductQtyModel.random();
    int test = await widget.databaseHelper.insert(palletProductQtyModel.tableName, palletProductQtyModel.toMap());
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
                    scanBarcode();
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