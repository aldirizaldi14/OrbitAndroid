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
//import 'package:unified_process/model/area_product_qty_model.dart';
import 'helper/database_helper.dart';
import 'model/userautocomplete309112.dart';
//import 'model/production_model.dart';
import 'deliverypicker.dart';
import 'deliverydetail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';

import 'package:unified_process/model/area_model.dart';
import 'package:unified_process/model/delivery309112_model.dart';

class DeliveryScanAddClass extends StatefulWidget {
  DeliveryScanAddClass({Key key}) : super(key: key);
  final String title = 'Data Truck Delivery';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  DeliveryScanAddState createState() {
    return DeliveryScanAddState();
  }
}

class DeliveryScanAddState extends State<DeliveryScanAddClass> {
  bool _enabled = false;
  AutoCompleteTextField searchTextField;
  TextEditingController productController = TextEditingController(text: '');
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  //final GlobalKey<FormBuilderState> formKeya = GlobalKey<FormBuilderState>();
  TextEditingController qrCodeCheckResult = TextEditingController(text: '');
  TextEditingController textFieldController = TextEditingController();
  String qrCodeResult = "Search S/J";

  //String qrCodeCheckResult = "None";
  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );
  void validateAndSave() {
    final FormState form = _formKeya.currentState;
    if (form.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  //untuk autocomplete
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeya = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String _selectedCity;
  //untuk autocomplete

  int product_id = 0;
  String barcodeValue = '';
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
      fetchDataBarcode(qrCodeResult);
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
        "WHERE product_code = ? AND quantity > 0",
        [barcodeScanCheck]);

    if (data.length > 0) {
      /*setState(() {
        qrCodeCheckResult.text = barcodeScanCheck;
      });*/
      setState(() {
        product_id = data[0]['product_id'];
        barcodeValue = data[0]['areaid'].toString();
        qrCodeCheckResult.text = barcodeValue;
      });
      if (data[0]['product_code'] == qrCodeCheckResult.text) {
        fetchDataBarcode(barcodeValue);
      } else {
        Toast.show("Invalid Product", context);
      }
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
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(5.5),
                    child: FormBuilder(
                        key: this._formKey,
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
                                            controller:
                                                this._typeAheadController,
                                            decoration: InputDecoration(
                                                labelText: 'Code Truck')),
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
                                      this._typeAheadController.text =
                                          suggestion;
                                      fetchDataBarcode(suggestion);
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please select a city';
                                      }
                                    },
                                    onSaved: (value) =>
                                        this._selectedCity = value,
                                  ),
                                ),
                              ],
                            ),

                            /*Row(
                              children: <Widget>[
                                Text(
                                  qrCodeResult,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),*/
                          ],
                        )),
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
                  Center(child: Text('Surat Jalan')),
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
                      0: FractionColumnWidth(.1)
                    },
                    children: productData),
              ),
            ),

            /*tambahan untuk detail table d/o number dari aldi */
            Expanded(
              child: SingleChildScrollView(
                child: FormBuilder(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                          bottom: 8.0,
                          top: 8.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print("Process data");
                  } else {
                    print("Eror");
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            /*SizedBox(
              width: double.infinity,
              child: SwitchListTile(
                value: _enabled,
                onChanged: (bool value) {
                  setState(() {
                    _enabled = value;
                  });
                },
              ),
            ),*/
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryTruckClass()),
                  );
                },
                child: Text(
                  'Go to Check FG',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }

  void fetchDataBarcode(String qrCodeResult) async {
    //print(areaId);
    print(qrCodeResult);
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery(
        "SELECT * FROM sj_number "
        "WHERE delivery_id = ?",
        [qrCodeResult]);
    print(allRows);

    /*final allRows = await db.rawQuery(
        "SELECT surat_jalan, order_item, ship_quantity FROM sj_number "
        "WHERE surat_jalan = ?",
        [qrCodeResult]);
    print(allRows);*/

    Widget menuItems(
        BuildContext context, String icon, String title, String route) {
      return Material(
          color: Colors.black,
          elevation: 10,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Image.asset(icon,
                      width: 75, height: 75, fit: BoxFit.fill),
                ),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )),
            onTap: () {
              if (route != '') {
                Navigator.pushNamed(context, route);
              }
            },
          ));
    }

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
                  _sendDataToSecondScreen(context);
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return DeliveryPickerClass();
                    }),
                  );*/
                  /*showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Detail I/N"),
                          //digunakan untuk body dialog
                          //content: Text(row['product_code'] ?? ''),
                          content: Text(row['product_code'] ?? ''),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });*/
                },
                child: Text(
                    textFieldController.text = row['surat_jalan'].toString())),
          ),
        ),
      ]));
    });
    setState(() {
      productData = rows;
    });
  }

  void _sendDataToSecondScreen(BuildContext context) {
    String textToSend = textFieldController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeliveryLoadingClass(
            userName: textToSend,
          ),
        ));
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
