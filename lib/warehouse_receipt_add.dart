import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/area_product_qty_model.dart';
import 'package:unified_process/model/receipt_model.dart';
import 'package:unified_process/model/receiptdet_model.dart';
import 'helper/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:toast/toast.dart';

class WarehouseReceiptAddClass extends StatefulWidget {
  WarehouseReceiptAddClass({ Key key}) : super (key: key);
  final String title = 'Receipt Add';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  WarehouseReceiptAddState createState() => WarehouseReceiptAddState();
}

class WarehouseReceiptAddState extends State<WarehouseReceiptAddClass> {
  String transferCode;
  List listData = [];
  bool isProcess = false;

  @override
  initState() {
    super.initState();
    openScanner();
  }

  Future<void> openScanner() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    final scanData = barcodeScanRes.split("###");
    final data = json.decode(scanData[1]).cast<Map<String, dynamic>>();
    print(scanData[0]);
    print(data);
    if(data.length > 0) {
      setState(() {
        transferCode = scanData[0];
        listData = data;
      });
    }
  }

  void saveData() async{
    Database db = await widget.databaseHelper.database;

    ReceiptModel receiptModel = ReceiptModel.instance;
    receiptModel.receipt_transfer_code = transferCode;
    receiptModel.receipt_code = randomAlpha(3) + new DateFormat("ddHHmm").format(new DateTime.now());
    receiptModel.receipt_time = new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
    receiptModel.receipt_sync = 0;
    int receipt_id = await widget.databaseHelper.insert(receiptModel.tableName, receiptModel.toMap());

    int status = 1;
    if(receipt_id > 0){
      for(int i =0; i < listData.length; i++){
        print(listData[i]);
        ReceiptdetModel receiptdetModel = ReceiptdetModel.instance;
        receiptdetModel.receiptdet_receipt_id = receipt_id;
        receiptdetModel.receiptdet_product_id = listData[i]['p'];
        receiptdetModel.receiptdet_transferdet_id = listData[i]['i'];
        receiptdetModel.receiptdet_qty = listData[i]['q'] is int ? listData[i]['q'] : int.parse(listData[i]['q']);
        receiptdetModel.receiptdet_note = '0';
        if(listData[i]['s'] == 2){
          status = 2;
        }
        await widget.databaseHelper.insert(receiptdetModel.tableName, receiptdetModel.toMap());

        // check if qty exist or not
        final check = await db.rawQuery("SELECT * FROM area_product_qty "
            "WHERE warehouse_id = 0 AND product_id = ? ", [listData[i]['p']]);
        if(check == null || check.length == 0){
          await db.rawInsert('INSERT INTO area_product_qty(warehouse_id, area_id, product_id, quantity) VALUES(0, 0, ?, ?)', [listData[i]['p'], listData[i]['q']]);
        }else{
          AreaProductQtyModel d = AreaProductQtyModel.fromDb(check[0]);
          int qty = d.quantity + receiptdetModel.receiptdet_qty;
          await db.rawQuery("UPDATE area_product_qty SET quantity = ? "
              "WHERE warehouse_id = 0 AND product_id = ? ", [qty, listData[i]['p']]);
        }
      }
      await db.rawQuery("UPDATE receipt SET receipt_status = ? "
          "WHERE receipt_id = ? ", [status, receipt_id]);
      setState(() {
        isProcess = false;
      });
      Navigator.pop(context);
    }
  }

  void invalidData(index) async{
    TextEditingController qtyController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input receipt amount'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    autofocus: true,
                    decoration: new InputDecoration(labelText: ''),
                    controller: qtyController,
                  )
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.lightBlueAccent,
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  listData[index]['n'] = listData[index]['q'];
                  listData[index]['q'] = qtyController.text;
                  listData[index]['s'] = 2;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
                  return Container(
                    color: (p['s'] == null ? 0 : p['s']) == 2 ? Colors.redAccent : Colors.transparent,
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(p['c'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(p['q'].toString() + (p['n'] == null ? '' : ' (' + p['n'].toString() + ')'), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                            ),
                            /*GestureDetector(
                              child: Icon(Icons.assignment_late),
                              onTap: () async {
                                invalidData(index);
                              },
                            )*/
                          ],
                        )
                    ),
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
                    if(! isProcess){
                      setState(() {
                        isProcess = true;
                      });
                      saveData();
                    }
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