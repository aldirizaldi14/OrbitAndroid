import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/delivery_model.dart';
import 'package:unified_process/model/deliverydet_model.dart';
import 'helper/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:toast/toast.dart';

class DeliveryAdd extends StatefulWidget {
  DeliveryAdd({ Key key }) : super (key: key);
  final String title = 'Add Delivery';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  DeliveryAddState createState() => DeliveryAddState();
}

class DeliveryAddState extends State<DeliveryAdd> {
  List listData = [];
  TextEditingController expeditionController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT deliverydet_id, deliverydet_qty, product_id, product_code "
        "FROM deliverydet "
        "JOIN product ON product.product_id = deliverydet.deliverydet_product_id "
        "WHERE deliverydet_delivery_id IS NULL "
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

  Future<void> openScanner() async {
    TextEditingController qtyController = TextEditingController();
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT product_id, product_code, product_description "
        "FROM product "
        "WHERE product_code = ? AND product_deleted_at IS NULL", [barcodeScanRes]
    );
    if(data.length > 0){
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(data[0]['product_description'].toString()),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(labelText: 'Input quantity'),
                      controller: qtyController,
                      keyboardType: TextInputType.numberWithOptions(),
                    )
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  qtyController.text = '';
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Colors.lightBlueAccent,
                child: Text('Add'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      if(qtyController.text != ''){
        DeliverydetModel deliverydetModel = DeliverydetModel.instance;
        deliverydetModel.deliverydet_product_id = data[0]['product_id'];
        deliverydetModel.deliverydet_qty = int.parse(qtyController.text);
        int deliverydetId = await widget.databaseHelper.insert(deliverydetModel.tableName, deliverydetModel.toMap());
        print(deliverydetId);
        if(deliverydetId > 0){
          fetchData();
        }else{
          Toast.show("Unable to save data", context);
        }
      }
    } else {
      Toast.show("Product invalid", context);
    }
  }

  void saveData() async{
    DeliveryModel deliveryModel = DeliveryModel.instance;
    deliveryModel.delivery_code = randomAlpha(3) + new DateFormat("ddHHmm").format(new DateTime.now());
    deliveryModel.delivery_time = new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
    deliveryModel.delivery_sync= 0;
    deliveryModel.delivery_expedition= expeditionController.text;
    deliveryModel.delivery_destination= destinationController.text;
    deliveryModel.delivery_city= cityController.text;
    int deliveryId = await widget.databaseHelper.insert(deliveryModel.tableName, deliveryModel.toMap());
    if(deliveryId > 0){
      Database db = await widget.databaseHelper.database;
      await db.rawQuery("UPDATE deliverydet SET deliverydet_delivery_id = ? "
          "WHERE deliverydet_delivery_id IS NULL", [deliveryId]
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async{
              await openScanner();
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              decoration: new InputDecoration(labelText: 'Expedition'),
              controller: expeditionController,
            ),
            TextField(
              autofocus: true,
              decoration: new InputDecoration(labelText: 'Destination'),
              controller: destinationController,
            ),
            TextField(
              autofocus: true,
              decoration: new InputDecoration(labelText: 'City'),
              controller: cityController,
            ),
            Text('- LIST ITEM -'),
            Expanded(
              child: listData.isEmpty ? Center(child: Text('No data available'),) : ListView.separated(
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
                              Text(p['deliverydet_qty'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                              Text(p['product_code'], style: TextStyle( fontSize: 12),),
                            ],
                          ),
                          GestureDetector(
                            child: Icon(Icons.delete),
                            onTap: () async {
                              await widget.databaseHelper.delete('deliverydet', 'deliverydet_id', p['deliverydet_id']);
                              fetchData();
                            },
                          )
                        ],
                      )
                  );
                },
                itemCount: listData.length,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () async {
                  if(listData.length > 0) {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm !'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              color: Colors.lightBlueAccent,
                              child: Text('Yes'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                saveData();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }else{
                    Toast.show('Add some data', context);
                  }
                },
                child: Text('Save', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        )
    );
  }
}