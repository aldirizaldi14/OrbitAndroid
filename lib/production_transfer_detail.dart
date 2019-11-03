import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'helper/database_helper.dart';

class ProductionTransferDetailClass extends StatefulWidget {
  int transferId;
  String transferCode;
  String transferSent;

  ProductionTransferDetailClass({ Key key, this.transferId, this.transferCode, this.transferSent }) : super (key: key);
  final String title = 'Transfer Detail';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductionTransferDetailState createState() => ProductionTransferDetailState();
}

class ProductionTransferDetailState extends State<ProductionTransferDetailClass> {
  List listData = [];
  bool viewList = true;
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
    print(widget.transferSent);
    print(widget.transferSent == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            widget.transferSent != null ? Container() :
            IconButton(
              icon: Icon((viewList ? FontAwesomeIcons.qrcode : FontAwesomeIcons.table), color: Colors.white,),
              onPressed: () {
                setState(() {
                  viewList = !viewList;
                });
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: viewList ? ListView.separated(
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
                                Text(p['c'], style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                              ],
                            ),
                            Text(p['q'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20),)
                          ],
                        )
                    );
                  },
                  itemCount: listData.length,
                ) : QrImage(
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