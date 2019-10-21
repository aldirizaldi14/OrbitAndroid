import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'helper/database_helper.dart';
import 'model/transfer_model.dart';

class ProductionTransferDetailClass extends StatefulWidget {
  int transferId;
  String transferCode;

  ProductionTransferDetailClass({ Key key, this.transferId, this.transferCode }) : super (key: key);
  final String title = 'Transfer Detail';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductionTransferDetailState createState() => ProductionTransferDetailState();
}

class ProductionTransferDetailState extends State<ProductionTransferDetailClass> {
  List listData = [];
  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT transferdet_id AS i, transferdet_qty AS q, product_id AS p, product_code AS c "
        "FROM transferdet "
        "JOIN product ON product.product_id = transferdet.transferdet_product_id "
        "WHERE transferdet_transfer_id = ?", [widget.transferId]
    );
    setState(() {
      listData = data;
    });
  }

  void saveData() async {
    Database db = await widget.databaseHelper.database;
    String transfer_at = new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
    await db.rawQuery("UPDATE transfer SET transfer_sent_at = ? "
        "WHERE transfer_id = ?", [transfer_at, widget.transferId]
    );
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
              child: Center(
                child: QrImage(
                  data: widget.transferCode + '###' + jsonEncode(listData),
                  version: QrVersions.auto,
                  size: double.infinity,
                ),
              ),
            ),
          ],
        ),
    );
  }
}