import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'helper/database_helper.dart';

class ProductionOutputClass extends StatefulWidget {
  ProductionOutputClass({ Key key}) : super (key: key);
  final String title = 'Production Output';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductionOutputState createState() => ProductionOutputState();
}

class ProductionOutputState extends State<ProductionOutputClass> {
  List productionData = [];
  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT production_id, production_code, product_code, production_time, production_qty, line_name, production_batch "
        "FROM production "
        "JOIN product ON product.product_id = production.production_product_id "
        "JOIN line ON line.line_id = production.production_line_id "
        "ORDER BY production_time DESC"
    );
    print(data);
    setState(() {
      productionData = data;
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
            await Navigator.pushNamed(context, '/production_output_add');
            fetchData();
          },
        ),
        body: productionData.isEmpty ? Center(child: Text('No data available'),) : ListView.separated(
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
                        Text(p['line_name'] + ' - ' + p['production_batch'], style: TextStyle( fontSize: 12),),
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