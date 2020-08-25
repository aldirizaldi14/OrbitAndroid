import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/area_model.dart';
import 'package:unified_process/model/delivery_model.dart';
import 'package:unified_process/model/deliverydet_model.dart';
import 'helper/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:toast/toast.dart';

final dialogAreaKey = new GlobalKey<DialogAreaState>();

class DeliveryAdd extends StatefulWidget {
  DeliveryAdd({Key key}) : super(key: key);
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
  List<AreaModel> listArea = [];

  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery(
        "SELECT deliverydet_id, deliverydet_qty, product_id, product_code "
        "FROM deliverydet "
        "JOIN product ON product.product_id = deliverydet.deliverydet_product_id "
        "WHERE deliverydet_delivery_id IS NULL ");
    print(data);
    setState(() {
      listData = data;
    });
  }

  @override
  initState() {
    super.initState();
    fetchArea();
  }

  Future<void> openScanner() async {
    TextEditingController qtyController = TextEditingController();
    AreaModel dropdownValue = listArea[0];

    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery(
        "SELECT product_id, product_code, product_description "
        "FROM product "
        "WHERE (product_code = ? OR product_code_alt = ?) AND product_deleted_at IS NULL",
        [barcodeScanRes, barcodeScanRes]);
    if (data.length > 0) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(data[0]['product_description'].toString()),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DialogArea(
                  listArea: listArea,
                  key: dialogAreaKey,
                ),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: new InputDecoration(labelText: 'Quantity'),
                  controller: qtyController,
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

      if (qtyController.text != '') {
        final check = await db.rawQuery(
            "SELECT quantity "
            "FROM area_product_qty "
            "WHERE area_id = ? AND product_id = ?",
            [
              dialogAreaKey.currentState.dropdownValue.area_id,
              data[0]['product_id']
            ]);
        if (check.length > 0) {
          int q = check[0]['quantity'] is int
              ? check[0]['quantity']
              : int.parse(check[0]['quantity']);
          if (q >= int.parse(qtyController.text)) {
            DeliverydetModel deliverydetModel = DeliverydetModel.instance;
            deliverydetModel.deliverydet_product_id = data[0]['product_id'];
            deliverydetModel.deliverydet_area_id =
                dialogAreaKey.currentState.dropdownValue.area_id;
            deliverydetModel.deliverydet_qty = int.parse(qtyController.text);
            int deliverydetId = await widget.databaseHelper
                .insert(deliverydetModel.tableName, deliverydetModel.toMap());
            if (deliverydetId > 0) {
              fetchData();
            } else {
              Toast.show("Unable to save data", context);
            }
          } else {
            Toast.show("Quantity only " + q.toString(), context,
                duration: Toast.LENGTH_LONG);
          }
        } else {
          Toast.show("No quantity in this area ", context,
              duration: Toast.LENGTH_LONG);
        }
      }
    } else {
      Toast.show("Product invalid", context);
    }
  }

  void saveData() async {
    DeliveryModel deliveryModel = DeliveryModel.instance;
    /*deliveryModel.delivery_code =
        randomAlpha(3) + new DateFormat("ddHHmm").format(new DateTime.now());
    deliveryModel.delivery_time =
        new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
    deliveryModel.delivery_sync = 0;
    deliveryModel.delivery_expedition = expeditionController.text;
    deliveryModel.delivery_destination = destinationController.text;
    deliveryModel.delivery_city = cityController.text;*/
    int deliveryId = await widget.databaseHelper
        .insert(deliveryModel.tableName, deliveryModel.toMap());
    if (deliveryId > 0) {
      Database db = await widget.databaseHelper.database;
      await db.rawQuery(
          "UPDATE deliverydet SET deliverydet_delivery_id = ? "
          "WHERE deliverydet_delivery_id IS NULL",
          [deliveryId]);
      final data = await db.rawQuery(
          "SELECT * FROM deliverydet WHERE deliverydet_delivery_id = ? ",
          [deliveryId]);
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          DeliverydetModel datum = DeliverydetModel.fromDb(data[i]);
          await db.rawQuery(
              "UPDATE area_product_qty SET quantity = quantity - ? "
              "WHERE area_id = ? AND product_id = ? ",
              [
                datum.deliverydet_qty,
                datum.deliverydet_area_id,
                datum.deliverydet_product_id
              ]);
        }
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
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
                  child: listData.isEmpty
                      ? Center(
                          child: Text('No data available'),
                        )
                      : ListView.separated(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          p['deliverydet_qty'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        Text(
                                          p['product_code'],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      child: Icon(Icons.delete),
                                      onTap: () async {
                                        await widget.databaseHelper.delete(
                                            'deliverydet',
                                            'deliverydet_id',
                                            p['deliverydet_id']);
                                        fetchData();
                                      },
                                    )
                                  ],
                                ));
                          },
                          itemCount: listData.length,
                        ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      if (listData.length > 0) {
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
                      } else {
                        Toast.show('Add some data', context);
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )));
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirm Exit?',
                style: new TextStyle(color: Colors.black, fontSize: 20.0)),
            content: new Text('Are you sure to stop delivery ?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () async {
                  Database db = await widget.databaseHelper.database;
                  await db.rawQuery(
                      "DELETE FROM deliverydet WHERE deliverydet_delivery_id IS NULL OR deliverydet_delivery_id = 0");
                  Navigator.popUntil(context, ModalRoute.withName('/delivery'));
                },
                child: new Text('Yes', style: new TextStyle(fontSize: 18.0)),
              ),
              new FlatButton(
                onPressed: () => Navigator.pop(context),
                child: new Text('No', style: new TextStyle(fontSize: 18.0)),
              )
            ],
          ),
        ) ??
        false;
  }

  void fetchArea() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT * "
        "FROM area "
        "WHERE area_deleted_at IS NULL ");
    for (int i = 0; i < data.length; i++) {
      setState(() {
        listArea.add(AreaModel.fromDb(data[i]));
      });
    }
  }
}

class DialogArea extends StatefulWidget {
  List<AreaModel> listArea;
  DialogArea({Key key, this.listArea}) : super(key: key);

  @override
  DialogAreaState createState() => DialogAreaState();
}

class DialogAreaState extends State<DialogArea> {
  AreaModel dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = widget.listArea[0];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DropdownButton<AreaModel>(
        isExpanded: true,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        value: dropdownValue,
        style: TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (AreaModel newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: widget.listArea.length == 0
            ? []
            : widget.listArea.map((AreaModel item) {
                return DropdownMenuItem<AreaModel>(
                    value: item, child: Text(item.area_name.toString()));
              }).toList());
  }
}
