import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/transfer_model.dart';
import 'package:unified_process/model/transferdet_model.dart';
import 'helper/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:toast/toast.dart';

class ProductionTransferAddClass extends StatefulWidget {
  ProductionTransferAddClass({ Key key }) : super (key: key);
  final String title = 'Add Transfer';
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
        "WHERE transferdet_transfer_id IS NULL"
    );
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
    final data = await db.rawQuery("SELECT product_id, product_code, product_description "
        "FROM product "
        "WHERE product_code = ? AND product_deleted_at IS NULL "
        "AND product_id NOT IN (SELECT transferdet_product_id FROM transferdet WHERE transferdet_transfer_id IS NULL)", [barcodeScanRes]
    );
    if(data.length > 0){
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(data[0]['product_description'].toString()),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(labelText: 'Input quantity'),
                      controller: qtyController,
                      keyboardType: TextInputType.numberWithOptions(),
                    )
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  qtyController.text = '';
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Add'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      if(qtyController.text != ''){
        Database db = await widget.databaseHelper.database;
        final check = await db.rawQuery("SELECT quantity "
            "FROM area_product_qty "
            "WHERE warehouse_id = 1 AND product_id = ?", [data[0]['product_id']]
        );
        if(check.length > 0){
          int q = check[0]['quantity'] is int ? check[0]['quantity'] : int.parse(check[0]['quantity']);
          if(q >= int.parse(qtyController.text)){
            TransferdetModel transferdetModel = TransferdetModel.instance;
            transferdetModel.transferdet_product_id = data[0]['product_id'];
            transferdetModel.transferdet_qty = int.parse(qtyController.text);
            int transferdet_id = await widget.databaseHelper.insert(transferdetModel.tableName, transferdetModel.toMap());
            if(transferdet_id > 0){
              fetchData();
            }else{
              Toast.show("Unable to save data", context);
            }
          }else{
            Toast.show("Quantity only " + q.toString(), context, duration: Toast.LENGTH_LONG);
          }
        }else{
          Toast.show("No Quantity", context, duration: Toast.LENGTH_LONG);
        }
      }
    } else {
      Toast.show("Product invalid or already used", context, duration: Toast.LENGTH_LONG);
    }
  }

  void saveData() async{
    TransferModel transferModel = TransferModel.instance;
    transferModel.transfer_code = randomAlpha(3) + new DateFormat("ddHHmm").format(new DateTime.now());
    transferModel.transfer_time = new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
    transferModel.transfer_sync = 0;
    int transfer_id = await widget.databaseHelper.insert(transferModel.tableName, transferModel.toMap());
    if(transfer_id > 0){
      Database db = await widget.databaseHelper.database;
      await db.rawQuery("UPDATE transferdet SET transferdet_transfer_id = ? "
          "WHERE transferdet_transfer_id IS NULL", [transfer_id]
      );

      final data = await db.rawQuery("SELECT * FROM transferdet WHERE transferdet_transfer_id = ? ", [transfer_id]);
      if(data.length > 0){
        for(int i=0; i<data.length; i++) {
          TransferdetModel datum = TransferdetModel.fromDb(data[i]);
          await db.rawQuery("UPDATE area_product_qty SET quantity = quantity - ? "
              "WHERE warehouse_id = 1 AND product_id = ? ", [datum.transferdet_qty, datum.transferdet_product_id]);
        }
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                onPressed: () async {
                  if(listData.length > 0) {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm !'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              color: Colors.lightBlueAccent,
                              child: Text('Yes'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                saveData();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }else{
                    Toast.show('Add some data', context);
                  }
                },
                child: Text('Save', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        )
      )
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Confirm Exit?',
            style: new TextStyle(color: Colors.black, fontSize: 20.0)),
        content: new Text('Are you sure to stop transfer ?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () async {
              Database db = await widget.databaseHelper.database;
                await db.rawQuery("DELETE FROM transferdet WHERE transferdet_transfer_id IS NULL"
              );
              Navigator.popUntil(context,  ModalRoute.withName('/production_transfer'));
            },
            child: new Text('Yes', style: new TextStyle(fontSize: 18.0)),
          ),
          new FlatButton(
            onPressed: () =>Navigator.pop(context),
            child: new  Text('No', style: new TextStyle(fontSize: 18.0)),
          )
        ],
      ),
    ) ?? false;
  }
}