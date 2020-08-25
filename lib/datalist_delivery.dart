import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:random_string/random_string.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:unified_process/deliveryloading.dart';
import 'package:unified_process/model/customerautocomplete309112.dart';
//import 'package:unified_process/model/area_product_qty_model.dart';
import 'deliverypicker.dart';
import 'helper/database_helper.dart';
import 'model/userautocomplete309112.dart';
//import 'model/production_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';

import 'package:unified_process/model/area_model.dart';
import 'package:unified_process/model/delivery309112_model.dart';

class DatalistDeliveryClass extends StatefulWidget {
  DatalistDeliveryClass({Key key, this.userName}) : super(key: key);
  final String title = 'Datalist S/J';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  final String userName;
  @override
  DatalistDeliveryState createState() => DatalistDeliveryState(userName);
}

class DatalistDeliveryState extends State<DatalistDeliveryClass> {
  //final String text;
  bool _enabled = false;
  final String text = "";
  AutoCompleteTextField searchTextField;
  TextEditingController productController = TextEditingController(text: '');
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> formKeya = GlobalKey<FormBuilderState>();
  TextEditingController qrCodeCheckResult = TextEditingController(text: '');
  TextEditingController qtyCheckResult = TextEditingController(text: '');
  final TextEditingController _typeETDController = TextEditingController();
  final TextEditingController _typeVehicleController = TextEditingController();
  String qrCodeResult = "Search S/J";
  //String qrCodeCheckResult = "None";
  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  String userName;
  DatalistDeliveryState(this.userName);
  //untuk autocomplete
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String _selectedCity;
  //untuk autocomplete

  int product_id = 0;
  String barcodeValue = '';
  String qtyValue = '';
  List lineData = [];

  void fieldBarcode() async {
    String barcodeScanRes;
    //print(areaId);
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery(
        "SELECT product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE area_product_qty.area_id = ? AND quantity > 0",
        [barcodeScanRes]);
    setState(() {
      product_id = data[0]['product_id'];
      barcodeValue = data[0]['area_id'];
      productController.text = barcodeValue;
      //openScanner();
    });
    //print(data);
  }

  void dataAutocomplete() async {
    String autoComplete;
    //print(areaId);
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery(
        "SELECT product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE area_product_qty.area_id = ? AND quantity > 0",
        [autoComplete]);
    setState(() {
      product_id = data[0]['product_id'];
      barcodeValue = data[0]['area_id'];
      productController.text = barcodeValue;
      //openScanner();
    });
    //print(data);
  }

  /* tambahan untuk detail fetch data tabel */
  List<AreaModel> listArea = [];
  List<Delivery309112Model> listSuratjalan = [];
  List<TableRow> productData = [];
  AreaModel dropdownValue;
  /* tambahan untuk detail fetch data tabel */

  @override
  initState() {
    super.initState();
    //fetchLineData();
    //fetchArea();
  }

  /*Future<void> openScanner() async {
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
        "SELECT product_id, product_code "
        "FROM product "
        "WHERE (product_code = ? OR product_code_alt = ?) AND product_deleted_at IS NULL",
        [barcodeScanRes, barcodeScanRes]);
    if (data.length > 0) {
      setState(() {
        product_id = data[0]['product_id'];
        barcodeValue = data[0]['product_code'];
        productController.text = barcodeValue;
      });
    } else {
      Toast.show("Invalid Product", context);
    }
  }*/

  void openScanner() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes.length > 0) {
      setState(() {
        qrCodeResult = barcodeScanRes;
      });
      //untuk menampilkan auto load tabel data surat jalan
      //fetchDataBarcode(qrCodeResult);
    } else {
      Toast.show("Invalid Product", context);
    }
  }

  //openscan untuk check jumlah quality barang pada tabel
  Future<void> openScannerCheck() async {
    String barcodeScanCheck;
    //String qrCodeCheckResultNone = 'none';
    try {
      barcodeScanCheck = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanCheck = 'Failed to get platform version.';
    }
    if (!mounted) return;
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery(
        "SELECT area_product_qty.area_id as areaid, product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE area_product_qty.area_id = 1 AND product_code = ? AND quantity > 0",
        [barcodeScanCheck]);

    if (data.length > 0) {
      /*setState(() {
        qrCodeCheckResult.text = barcodeScanCheck;
      });*/
      setState(() {
        product_id = data[0]['product_id'];
        barcodeValue = data[0]['product_code'].toString();
        qtyValue = data[0]['quantity'].toString();
        qrCodeCheckResult.text = barcodeValue;
        qtyCheckResult.text = qtyValue;
      });
      /*if (data[0]['product_code'] == qrCodeCheckResult.text) {
        fetchDataBarcode(barcodeValue);
      } 
      else {
        Toast.show("Invalid Product", context);
      }*/
    } else {
      Toast.show("Invalid Product", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _onPressed;
    if (_enabled) {
      _onPressed = () {
        print("Tap");
      };
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check_box),
          onPressed: () async {
            await Navigator.pushNamed(context, '/deliveryloading');
            //fetchData();
          },
        ),
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 7, left: 15, right: 15),
                    child: FormBuilder(
                      //key: this._formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TypeAheadFormField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                          controller: this._typeETDController,
                                          decoration: InputDecoration(
                                              prefixIcon:
                                                  Icon(Icons.calendar_today),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        25.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(15.0),
                                              labelText: 'ETD Search')),
                                  suggestionsCallback: (pattern) {
                                    return CitiesService.getSuggestions(
                                        pattern);
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    this._typeETDController.text = suggestion;
                                    if (suggestion != true) {
                                      fetchDataETD();
                                    } else {
                                      fetchDataBarcode();
                                    }
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please select a S/J';
                                    }
                                  },
                                  onSaved: (value) =>
                                      this._selectedCity = value,
                                ),
                                /* child: FormBuilderTextField(
                                  //qrCodeResult,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.left,
                                  attribute: "product_id",
                                  controller: qrCodeCheckResult,
                                  decoration: InputDecoration(labelText: "S/J"),
                                  readOnly: true,
                                ),*/
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5, right: 1),
                                  child: TypeAheadFormField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            controller:
                                                this._typeVehicleController,
                                            decoration: InputDecoration(
                                                prefixIcon:
                                                    Icon(Icons.departure_board),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(15.0),
                                                labelText: 'Vehicle Search')),
                                    suggestionsCallback: (pattern) {
                                      return CustomerService.getSuggestions(
                                          pattern);
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion),
                                      );
                                    },
                                    transitionBuilder:
                                        (context, suggestionsBox, controller) {
                                      return suggestionsBox;
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      this._typeVehicleController.text =
                                          suggestion;
                                      if (suggestion != true) {
                                        fetchDataVehicle();
                                      } else {
                                        fetchDataBarcode();
                                      }
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please select a customer';
                                      }
                                    },
                                    onSaved: (value) =>
                                        this._selectedCity = value,
                                  ),
                                ),

                                /* child: FormBuilderTextField(
                                  //qrCodeResult,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.left,
                                  attribute: "product_id",
                                  controller: qrCodeCheckResult,
                                  decoration: InputDecoration(labelText: "S/J"),
                                  readOnly: true,
                                ),*/
                              ),
                              /*Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Enter Customer",
                                      contentPadding:
                                          const EdgeInsets.all(15.0),
                                      fillColor: Colors.white,
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        borderSide: new BorderSide(),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val.length == 0) {
                                        return "Customer cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    style: new TextStyle(
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),

                                /* child: FormBuilderTextField(
                                  //qrCodeResult,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.left,
                                  attribute: "product_id",
                                  controller: qrCodeCheckResult,
                                  decoration: InputDecoration(labelText: "S/J"),
                                  readOnly: true,
                                ),*/
                              ),*/
                            ],
                          ),
                          new Container(
                            child: new Text(""),
                            margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TypeAheadFormField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                          controller: this._typeAheadController,
                                          decoration: InputDecoration(
                                              prefixIcon:
                                                  Icon(Icons.insert_drive_file),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        25.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(15.0),
                                              labelText: 'Surat Jalan')),
                                  suggestionsCallback: (pattern) {
                                    return CitiesService.getSuggestions(
                                        pattern);
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    this._typeAheadController.text = suggestion;
                                    fetchDataBarcode();
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please select a city';
                                    }
                                  },
                                  onSaved: (value) =>
                                      this._selectedCity = value,
                                ),
                                /* child: FormBuilderTextField(
                                  //qrCodeResult,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.left,
                                  attribute: "product_id",
                                  controller: qrCodeCheckResult,
                                  decoration: InputDecoration(labelText: "S/J"),
                                  readOnly: true,
                                ),*/
                              ),
                            ],
                          ),
                          new Container(
                            child: new Text(""),
                            margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Table(border: TableBorder.all(color: Colors.black), columnWidths: {
              0: FractionColumnWidth(.1),
              2: FractionColumnWidth(.3),
              2: FractionColumnWidth(.2),
              //3: FractionColumnWidth(.2),
              0: FractionColumnWidth(.1)
            }, children: [
              TableRow(
                children: [
                  Center(child: Text('#')),
                  Center(child: Text('S/J')),
                  Center(child: Text('Vehicle ID')),
                  Center(child: Text('Status')),
                ],
              ),
            ]),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: {
                      0: FractionColumnWidth(.1),
                      2: FractionColumnWidth(.3),
                      2: FractionColumnWidth(.2),
                      //3: FractionColumnWidth(.2),
                      0: FractionColumnWidth(.1)
                    },
                    children: productData),
              ),
            ),
          ],
        ));
  }

  void fetchDataBarcode() async {
    //print(areaId);
    //final TextEditingController _typeSJController = TextEditingController();
    print(_typeETDController.text);
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery(
        "SELECT area_product_qty.area_id as areaid, product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE area_product_qty.area_id = ? AND product_code = ? AND quantity > 0",
        [_typeETDController.text, _typeVehicleController.text]);
    print(allRows);

    /*final allRows = await db.rawQuery(
        "SELECT surat_jalan, order_item, ship_quantity FROM sj_number "
        "WHERE surat_jalan = ?",
        [qrCodeResult]);
    print(allRows);*/

    List<TableRow> rows = [];
    int i = 0;
    allRows.forEach((row) {
      ++i;
      rows.add(TableRow(children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(i.toString())),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryLoadingClass()),
                  );
                },
                child: Text(row['product_code'] ?? '')),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['quantity'].toString())),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['quantity'].toString())),
        ),
      ]));
    });
    setState(() {
      productData = rows;
    });
  }

  void fetchDataETD() async {
    //print(areaId);
    //final TextEditingController _typeSJController = TextEditingController();
    print(_typeETDController.text);
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery(
        "SELECT area_product_qty.area_id as areaid, product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE area_product_qty.area_id = ? AND quantity > 0",
        [_typeETDController.text]);
    print(allRows);

    /*final allRows = await db.rawQuery(
        "SELECT surat_jalan, order_item, ship_quantity FROM sj_number "
        "WHERE surat_jalan = ?",
        [qrCodeResult]);
    print(allRows);*/

    List<TableRow> rows = [];
    int i = 0;
    allRows.forEach((row) {
      ++i;
      rows.add(TableRow(children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(i.toString())),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryLoadingClass()),
                  );
                },
                child: Text(row['product_code'] ?? '')),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['quantity'].toString())),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['quantity'].toString())),
        ),
      ]));
    });
    setState(() {
      productData = rows;
    });
  }

  void fetchDataVehicle() async {
    //print(areaId);
    //final TextEditingController _typeSJController = TextEditingController();
    print(_typeVehicleController.text);
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery(
        "SELECT area_product_qty.area_id as areaid, product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE product_code = ? AND quantity > 0",
        [_typeVehicleController.text]);
    print(allRows);

    /*final allRows = await db.rawQuery(
        "SELECT surat_jalan, order_item, ship_quantity FROM sj_number "
        "WHERE surat_jalan = ?",
        [qrCodeResult]);
    print(allRows);*/

    List<TableRow> rows = [];
    int i = 0;
    allRows.forEach((row) {
      ++i;
      rows.add(TableRow(children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(i.toString())),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryLoadingClass()),
                  );
                },
                child: Text(row['product_code'] ?? '')),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['quantity'].toString())),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['quantity'].toString())),
        ),
      ]));
    });
    setState(() {
      productData = rows;
    });
  }

  void fetchData(int areaId) async {
    print(areaId);
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery(
        "SELECT product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE area_product_qty.area_id = ? AND quantity > 0",
        [areaId]);
    print(allRows);

    List<TableRow> rows = [];
    int i = 0;
    allRows.forEach((row) {
      ++i;
      rows.add(TableRow(children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(i.toString())),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(row['product_code'] ?? ''),
        ),
        /*Padding(
          padding: EdgeInsets.all(5),
          child: Text(row['quantity'] ?? ''),
        ),*/
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['quantity'].toString())),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(
              child: InkWell(
            onTap: () {
              openScanner();
            },
            child: Icon(
              FontAwesomeIcons.barcode,
              size: 20,
            ),
          )),
        ),
      ]));
    });
    setState(() {
      productData = rows;
    });
  }
  /*tambahan untuk query fetch detail table d/o number dari aldi */
}
