import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/receipt_detail.dart';
import 'helper/database_helper.dart';

class WarehouseReceiptClass extends StatefulWidget {
  WarehouseReceiptClass({ Key key}) : super (key: key);
  final String title = 'Receipt';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  WarehouseReceiptState createState() => WarehouseReceiptState();
}

class WarehouseReceiptState extends State<WarehouseReceiptClass> {
  List listData = [];
  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("select receipt_id,receipt_code,receipt_time,receiptdet_qty,product_code from  receipt join receiptdet "
    " on receipt.receipt_id=receiptdet.receiptdet_receipt_id "
    " JOIN product ON receiptdet.receiptdet_product_id=product.product_id "
        " WHERE receipt_deleted_at IS NULL "
        " ORDER BY receipt_time DESC"
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async{
            await Navigator.pushNamed(context, '/warehouse_receipt_add');
            fetchData();
          },
        ),
        body: listData.isEmpty ? Center(child: Text('No data available'),) : ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey,
            );
          },
          itemBuilder: (context, index) {
            final p = listData[index];
            return Container(
              //color: p['receipt_status'] == 1 ? Colors.greenAccent : Colors.redAccent,
              child: InkWell(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(p['product_code'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                            Text(p['receipt_time'].toString(), style: TextStyle( fontSize: 12),),
                          ],
                        ),
                        Text(p['receiptdet_qty'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20),)
                      ],
                    )
                ),
              /*  onTap: () {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) => new ReceiptDetailClass(receiptId: p['receipt_id']))
                  ).then((value) {
                    fetchData();
                  });
                },*/
              ),
            );
          },
          itemCount: listData.length,
        )
    );
  }
}