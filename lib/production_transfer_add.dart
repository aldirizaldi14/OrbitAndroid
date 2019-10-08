import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/transfer_model.dart';
import 'package:unified_process/model/transferdet_model.dart';
import 'helper/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:toast/toast.dart';

class ProductionTransferAddClass extends StatefulWidget {
  ProductionTransferAddClass({ Key key}) : super (key: key);
  final String title = 'Transfer Add';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductionTransferAddState createState() => ProductionTransferAddState();
}

class ProductionTransferAddState extends State<ProductionTransferAddClass> {
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
    fetchData();
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
    final data = await db.rawQuery("SELECT product_id, product_code "
        "FROM product "
        "WHERE product_code = ? AND product_deleted_at IS NULL", [barcodeScanRes]
    );
    if(data.length > 0){
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Input Quantity'),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(labelText: ''),
                      controller: qtyController,
                    )
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      TransferdetModel transferdetModel = TransferdetModel.instance;
      transferdetModel.transferdet_product_id = data[0]['product_id'];
      transferdetModel.transferdet_qty = int.parse(qtyController.text);
      int transferdet_id = await widget.databaseHelper.insert(transferdetModel.tableName, transferdetModel.toMap());
      if(transferdet_id > 0){
        fetchData();
      }else{
        Toast.show("Unable to save data", context);
      }
    } else {
      Toast.show("Product invalid", context);
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
              await openScanner();
            },
          ),
        ),
        body: Column(
          children: <Widget>[
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
                              Text(p['transferdet_qty'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                              Text(p['product_code'], style: TextStyle( fontSize: 12),),
                            ],
                          ),
                          GestureDetector(
                            child: Icon(Icons.delete),
                            onTap: () async {
                              await widget.databaseHelper.delete('transferdet', 'transferdet_id', p['transferdet_id']);
                              fetchData();
                            },
                          )
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