import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/transfer_model.dart';
import 'package:unified_process/model/transferdet_model.dart';
import 'helper/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:toast/toast.dart';

class WarehouseAllocationClass extends StatefulWidget {
  WarehouseAllocationClass({ Key key}) : super (key: key);
  final String title = 'Warehouse Allocation';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  WarehouseAllocationState createState() => WarehouseAllocationState();
}

class WarehouseAllocationState extends State<WarehouseAllocationClass> {
  List listData = [];
  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT transferdet_id, transferdet_transfer_id, transferdet_qty, product_id, product_code "
        "FROM transferdet "
        "JOIN product ON product.product_id = transferdet.transferdet_product_id "
    );
    print(data);
    setState(() {
      listData = data;
    });
  }

  @override
  initState() {
    super.initState();
  }

  Future<void> openScanner() async {
    TextEditingController qtyController = TextEditingController();
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT * "
        "FROM area_product_qty "
        "JOIN product ON product.product_id = area_product_qty.product_id "
        "WHERE product_code = ? AND warehouse_id = 0", [barcodeScanRes]
    );
    print(data);
    if(data.length > 0){
      setState(() {
        listData = data;
      });
    } else {
      Toast.show("Product doesn't have unallocated stock", context);
    }
  }

  void saveData() async{
    TransferModel transferModel = TransferModel.instance;
    transferModel.transfer_code = new DateFormat("yyyyMMddhhmmss").format(new DateTime.now());
    transferModel.transfer_time = new DateFormat("yyyy-MM-dd hh:mm:ss").format(new DateTime.now());
    int transfer_id = await widget.databaseHelper.insert(transferModel.tableName, transferModel.toMap());
    if(transfer_id > 0){
      Database db = await widget.databaseHelper.database;
      await db.rawQuery("UPDATE transferdet SET transferdet_transfer_id = ? "
          "WHERE transferdet_transfer_id IS NULL", [transfer_id]
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async{

            },
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  openScanner();
                },
                child: Text('Scan Item', style: TextStyle(color: Colors.white),),
              ),
            ),
            Expanded(
              child: listData.isEmpty ? Center(child: Text('No data available'),) : ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                  );
                },
                itemBuilder: (context, index) {
                  final p = listData[index];
                  return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(p['quantity'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                              Text('Unallocated', style: TextStyle( fontSize: 12),),
                            ],
                          ),
                        ],
                      )
                  );
                },
                itemCount: listData.length,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  if(listData.length > 0) {
                    saveData();
                  }else{
                    Toast.show('Add some data', context);
                  }
                },
                child: Text('Save', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        )
    );
  }
}