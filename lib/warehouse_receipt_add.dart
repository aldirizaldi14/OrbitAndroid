import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/transfer_model.dart';
import 'package:unified_process/model/transferdet_model.dart';
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
  List listData = [];
  @override
  initState() {
    super.initState();
    openScanner();
  }

  Future<void> openScanner() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    final data = json.decode(barcodeScanRes).cast<Map<String, dynamic>>();
    if(data.length > 0) {
      setState(() {
        listData = data;
      });
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

  void invalidData(index) async{
    TextEditingController qtyController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input some notes'),
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
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    setState(() {
      listData[index]['note'] = qtyController.text;
      listData[index]['status'] = 2;
    });
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
                    color: (p['status'] == null ? 0 : p['status']) == 2 ? Colors.redAccent : Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(p['product_code'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                                  Text(p['note'] == null ? '' : p['note'].toString(), style: TextStyle( fontSize: 12),),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(p['transferdet_qty'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                            ),
                            GestureDetector(
                              child: Icon(Icons.assignment_late),
                              onTap: () async {
                                invalidData(index);
                              },
                            )
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