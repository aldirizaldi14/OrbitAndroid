import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/area_model.dart';
import 'helper/database_helper.dart';

class TagCount extends StatefulWidget {
  TagCount({ Key key}) : super (key: key);
  final String title = 'Tag Count';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  TagCountState createState() => TagCountState();
}

class TagCountState extends State<TagCount> {
  List<AreaModel> listArea = [];
  List<TableRow> productData = [];
  AreaModel dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchArea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButton<AreaModel>(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        value: dropdownValue,
                        style: TextStyle(
                            color: Colors.deepPurple
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (AreaModel newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: listArea.length == 0 ? [] : listArea.map((AreaModel item) {
                          return DropdownMenuItem<AreaModel>(
                              value: item,
                              child: Text(item.area_name.toString())
                          );
                        }
                        ).toList()
                    ),
                  ),
                  FlatButton(
                    color: Colors.lightBlue,
                    child: Icon(Icons.search),
                    onPressed: () {
                      fetchData(dropdownValue.area_id);
                    },
                  )
                ],
              ),
              Container(height: 10,),
              Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.3), 3: FractionColumnWidth(.2)},
                  children: [
                    TableRow(
                      children: [
                        Center(child: Text('#')),
                        Center(child: Text('Product Code')),
                        Center(child: Text('Description')),
                        Center(child: Text('Qty')),
                      ],
                    ),
                  ]
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.3), 3: FractionColumnWidth(.2)},
                      children: productData
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  void fetchArea() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT * "
        "FROM area "
        "WHERE area_deleted_at IS NULL "
    );
    for(int i=0; i < data.length; i++){
      setState(() {
        listArea.add(AreaModel.fromDb(data[i]));
      });
    }
  }

  void fetchData(int areaId) async {
    print(areaId);
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery("SELECT product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE area_product_qty.area_id = ? AND quantity > 0", [areaId]
    );
    print(allRows);

    List<TableRow> rows = [];
    int i = 0;
    allRows.forEach((row){
      ++i;
      rows.add(TableRow(
          children: [
            Padding(padding: EdgeInsets.all(5), child: Center(child: Text(i.toString())),),
            Padding(padding: EdgeInsets.all(5), child: Text(row['product_code'] ?? ''),),
            Padding(padding: EdgeInsets.all(5), child: Text(row['product_description'] ?? ''),),
            Padding(padding: EdgeInsets.all(5), child: Center(child: Text(row['quantity'].toString())),),
          ]
      ));
    });
    setState(() {
      productData = rows;
    });
  }
}