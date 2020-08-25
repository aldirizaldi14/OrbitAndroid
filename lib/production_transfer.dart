import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'helper/database_helper.dart';
import 'package:unified_process/production_transfer_detail.dart';

class ProductionTransferClass extends StatefulWidget {
  ProductionTransferClass({Key key}) : super(key: key);
  final String title = 'Transfer';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductionTransferState createState() => ProductionTransferState();
}

class ProductionTransferState extends State<ProductionTransferClass> {
  List listData = [];
  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery(
        "SELECT transfer_id, transfer_code, transfer_time, transfer_updated_at, transfer_sent_at,transferdet_qty,product_code "
        " FROM transfer "
        " JOIN transferdet ON transfer.transfer_id=transferdet.transferdet_transfer_id"
        " JOIN product ON product.product_id = transferdet.transferdet_product_id "
        "ORDER BY transfer_time DESC");
    setState(() {
      listData = data;
    });
  }

  @override
  initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.pushNamed(context, '/production_transfer_add');
            fetchData();
          },
        ),
        body: listData.isEmpty
            ? Center(
                child: Text('No data available'),
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                    height: 1,
                  );
                },
                itemBuilder: (context, index) {
                  final p = listData[index];
                  return Container(
                    color: p['transfer_sent_at'] == null
                        ? Colors.transparent
                        : Colors.greenAccent,
                    child: InkWell(
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    p['product_code'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    p['transferdet_qty'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    p['transfer_time'].toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          )),
                      onTap: () {
                        print(p['transfer_sent_at']);
                        Navigator.of(context)
                            .push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new ProductionTransferDetailClass(
                                        transferId: p['transfer_id'],
                                        transferCode: p['transfer_code'],
                                        transferSent: p['transfer_sent_at'])))
                            .then((value) {
                          fetchData();
                        });
                      },
                    ),
                  );
                },
                itemCount: listData.length,
              ));
  }
}
