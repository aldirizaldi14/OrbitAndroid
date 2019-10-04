import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'helper/database_helper.dart';

class WarehouseReceiptClass extends StatefulWidget {
  WarehouseReceiptClass({ Key key}) : super (key: key);
  final String title = 'Warehouse Receipt';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  WarehouseReceiptState createState() => WarehouseReceiptState();
}

class WarehouseReceiptState extends State<WarehouseReceiptClass> {
  List listData = [];
  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT receipt_id, receipt_time, receipt_status "
        "FROM receipt "
        "ORDER BY receipt_time DESC"
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
              color: int.parse(p['receipt_status']) == 1 ? Colors.greenAccent : Colors.redAccent,
              child: InkWell(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(p['receipt_time'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                          ],
                        ),
                        Icon(Icons.keyboard_arrow_right)
                      ],
                    )
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/warehouse_receipt_detail', arguments: [p['receipt_id']]);
                },
              ),
            );
          },
          itemCount: listData.length,
        )
    );
  }
}