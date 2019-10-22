import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'helper/database_helper.dart';
import 'package:unified_process/production_transfer_detail.dart';

class Delivery extends StatefulWidget {
  Delivery({ Key key}) : super (key: key);
  final String title = 'Delivery';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  DeliveryState createState() => DeliveryState();
}

class DeliveryState extends State<Delivery> {
  List listData = [];
  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    //widget.databaseHelper.dummyData(db);
    final data = await db.rawQuery("SELECT delivery_id, delivery_code, delivery_time, delivery_destination "
        "FROM delivery "
        "ORDER BY delivery_time DESC"
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
            await Navigator.pushNamed(context, '/delivery_add');
            fetchData();
          },
        ),
        body: listData.isEmpty ? Center(child: Text('No data available'),) : ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey,
              height: 1,
            );
          },
          itemBuilder: (context, index) {
            final p = listData[index];
            return Container(
              child: InkWell(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(p['delivery_code'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                            Text(p['delivery_time'].toString(), style: TextStyle( fontSize: 12),),
                          ],
                        ),
                        //Icon(Icons.keyboard_arrow_right)
                      ],
                    )
                ),
                onTap: () {
                  /*
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) => new ProductionTransferDetailClass(transferId: p['transfer_id'], transferCode: p['transfer_code']))
                  ).then((value) {
                    fetchData();
                  });
                  */
                },
              ),
            );
          },
          itemCount: listData.length,
        )
    );
  }
}