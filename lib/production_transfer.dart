import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:sqflite/sqflite.dart';
import 'helper/database_helper.dart';

class ProductionTransferClass extends StatefulWidget {
  ProductionTransferClass({ Key key}) : super (key: key);
  final String title = 'Production Transfer';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductionTransferState createState() => ProductionTransferState();
}

class ProductionTransferState extends State<ProductionTransferClass> {
  List listData = [];
  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT transfer_id,transfer_code, transfer_time "
        "FROM transfer "
        "ORDER BY transfer_time DESC"
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
            await Navigator.pushNamed(context, '/production_transfer_add');
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
            return InkWell(
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(p['transfer_id'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                          Text(p['transfer_time'], style: TextStyle( fontSize: 12),),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  )
              ),
              onTap: () {
                Navigator.pushNamed(context, '/production_transfer_detail', arguments: [p['transfer_id']]);
              },
            );
          },
          itemCount: listData.length,
        )
    );
  }
}