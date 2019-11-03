import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'helper/database_helper.dart';

class ReceiptDetailClass extends StatefulWidget {
  int receiptId;

  ReceiptDetailClass({ Key key, this.receiptId }) : super (key: key);
  final String title = 'Receipt Detail';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ReceiptDetailState createState() => ReceiptDetailState();
}

class ReceiptDetailState extends State<ReceiptDetailClass> {
  List listData = [];
  bool viewList = true;
  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT receiptdet_id AS i, receiptdet_qty AS q, product_id AS p, product_code AS c "
        "FROM receiptdet "
        "JOIN product ON product.product_id = receiptdet.receiptdet_product_id "
        "WHERE receiptdet_receipt_id = ?", [widget.receiptId]
    );
    setState(() {
      listData = data;
    });
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
              child: ListView.separated(
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
                              Text(p['c'], style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20),),
                            ],
                          ),
                          Text(p['q'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20),)
                        ],
                      )
                  );
                },
                itemCount: listData.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}