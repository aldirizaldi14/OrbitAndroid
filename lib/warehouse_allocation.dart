import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unified_process/model/allocation_model.dart';
import 'package:unified_process/model/allocationdet_model.dart';
import 'package:unified_process/model/area_model.dart';
import 'package:unified_process/model/transfer_model.dart';
import 'package:unified_process/model/transferdet_model.dart';
import 'helper/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:toast/toast.dart';

final dialogAreaKey = new GlobalKey<DialogAreaState>();

class WarehouseAllocationClass extends StatefulWidget {
  WarehouseAllocationClass({ Key key}) : super (key: key);
  final String title = 'Allocation';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  WarehouseAllocationState createState() => WarehouseAllocationState();
}

class WarehouseAllocationState extends State<WarehouseAllocationClass> {
  List<AreaModel> listArea = [];
  List listData = [];
  int productId;
  String productCode;
  String productDesc;
  int unallocatedQty;

  @override
  initState() {
    super.initState();
    fetchArea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                openScanner();
              },
            )
          ],
        ),
        floatingActionButton: Visibility(
          visible: productCode == null ? false : true,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async{
                if(unallocatedQty > 0){
                  inputDetail();
                }else{
                  Toast.show('No more unallocated quantity.', context);
                }
              },
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Text(productCode == null ? '' : productCode, style: TextStyle(fontSize: 17),),
            Text(productDesc == null ? '' : productDesc, style: TextStyle(fontSize: 12),),
            Text(unallocatedQty == null ? '' : 'Unallocated Qty : ' + unallocatedQty.toString(), style: TextStyle(fontSize: 20),),
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
                          Expanded(
                            child: Text(p['area_name'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(p['allocationdet_qty'].toString(), style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17),),
                          ),
                          GestureDetector(
                            child: Icon(Icons.delete),
                            onTap: () async {
                              deleteDetail(p['allocationdet_id'], p['allocationdet_qty']);
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
                onPressed: () {
                  if(listData.length > 0) {
                    saveData();
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

  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT allocationdet_id, allocationdet_area_id, allocationdet_qty, area_name "
        "FROM allocationdet "
        "JOIN area ON area.area_id = allocationdet.allocationdet_area_id "
    );
    print(data);
    setState(() {
      listData = data;
    });
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
    final data = await db.rawQuery("SELECT * "
        "FROM area_product_qty "
        "JOIN product ON product.product_id = area_product_qty.product_id "
        "WHERE product_code = ? AND area_id = 0", [barcodeScanRes]
    );
    if(data.length > 0){
      setState(() {
        productId = data[0]['product_id'];
        productCode = data[0]['product_code'];
        productDesc = data[0]['product_description'];
        unallocatedQty = data[0]['quantity'];
      });
    } else {
      Toast.show("Product doesn't have unallocated stock", context);
    }
  }

  void saveData() async{
    AllocationModel allocationModel = AllocationModel.instance;
    allocationModel.allocation_product_id = productId;
    allocationModel.allocation_code = randomAlpha(3) + new DateFormat("ddHHmm").format(new DateTime.now());
    allocationModel.allocation_time = new DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
    allocationModel.allocation_sync = 0;
    int allocationId = await widget.databaseHelper.insert(allocationModel.tableName, allocationModel.toMap());
    if(allocationId > 0){
      Database db = await widget.databaseHelper.database;
      await db.rawQuery("UPDATE allocationdet SET allocationdet_allocation_id = ? "
          "WHERE allocationdet_allocation_id = 0", [allocationId]
      );
      Navigator.pop(context);
    }
  }

  void saveDetail(int area, int qty) async{
    AllocationdetModel allocationdetModel = AllocationdetModel.instance;
    allocationdetModel.allocationdet_allocation_id = 0;
    allocationdetModel.allocationdet_area_id = area;
    allocationdetModel.allocationdet_qty = qty;
    int detId = await widget.databaseHelper.insert(allocationdetModel.tableName, allocationdetModel.toMap());
    fetchData();
  }

  void deleteDetail(int id, int qty) async{
    Database db = await widget.databaseHelper.database;
    await db.rawQuery("DELETE FROM allocationdet "
        "WHERE allocationdet_id = ?", [id]
    );
    setState(() {
      unallocatedQty += qty;
    });
    fetchData();
  }

  void inputDetail() async{
    TextEditingController qtyController = TextEditingController();
    AreaModel dropdownValue = listArea[0];
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input allocation detail'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DialogArea(listArea: listArea, key: dialogAreaKey,),
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
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.lightBlueAccent,
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                saveDetail(dialogAreaKey.currentState.dropdownValue.area_id, int.parse(qtyController.text));
                setState(() {
                  unallocatedQty -= int.parse(qtyController.text);
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class DialogArea extends StatefulWidget {
  List<AreaModel> listArea;
  DialogArea({ Key key, this.listArea }) : super (key: key);

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
        items: widget.listArea.length == 0 ? [] : widget.listArea.map((AreaModel item) {
          return DropdownMenuItem<AreaModel>(
              value: item,
              child: Text(item.area_name.toString())
          );
        }
        ).toList()
    );
  }
}