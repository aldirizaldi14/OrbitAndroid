import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'model/production.dart';
import 'helper/database_helper.dart';

class ProductionOutputClass extends StatefulWidget {
  ProductionOutputClass({ Key key}) : super (key: key);
  final String title = 'Product Output';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductionOutputState createState() => ProductionOutputState();
}

class ProductionOutputState extends State<ProductionOutputClass> {
  List productionData = [];
  void fetchData(String product_code) async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT production_id, product_name, production_time, production_qty FROM production "
        "JOIN product ON product.product_id = production.product_id "
        "WHERE production_deleted_at IS NULL"
    );
    print(data);
    if(data.length > 0){
      setState(() {
        productionData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, '/production_output_add'),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey,
            );
          },
          itemBuilder: (context, index) {
            final p = productionData[index];
            return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(p['product_code'], style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                        Text(p['production_time'], style: TextStyle( fontSize: 12),),
                      ],
                    ),
                    Text(p['production_qty'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20),)
                  ],
                )
            );
          },
          itemCount: productionData.length,
        )
    );
  }
}