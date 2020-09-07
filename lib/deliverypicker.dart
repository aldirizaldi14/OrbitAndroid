import 'dart:convert';
import 'dart:ffi';

import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:random_string/random_string.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:unified_process/menu.dart';
import 'package:unified_process/model/customerautocomplete309112.dart';
//import 'package:unified_process/model/area_product_qty_model.dart';
import 'helper/database_helper.dart';
import 'model/userautocomplete309112.dart';
//import 'model/production_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';

import 'package:unified_process/model/area_model.dart';
import 'package:unified_process/model/delivery309112_model.dart';

const List<Key> keys = [
  Key("Network"),
  Key("NetworkDialog"),
  Key("Flare"),
  Key("FlareDialog"),
  Key("Asset"),
  Key("AssetDialog")
];

class DeliveryPickerClass extends StatefulWidget {
  final String userName;
  String surat_jalan;

  DeliveryPickerClass({Key key, this.userName, this.surat_jalan }) : super(key: key);
  final String title = 'Checked Picker';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  DeliveryPickerState createState() => DeliveryPickerState(userName);
}

class DeliveryPickerState extends State<DeliveryPickerClass> {
  //final String text;
  bool _enabled = false;
  final String text = "";
  AutoCompleteTextField searchTextField;
  TextEditingController productController = TextEditingController(text: '');
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> formKeya = GlobalKey<FormBuilderState>();
  TextEditingController qrCodeCheckResult = TextEditingController(text: '');
  TextEditingController qtyController = TextEditingController(text: '');
  TextEditingController qtyCheckController = TextEditingController(text: '');

  String qrCodeResult = "Search S/J";
  //String qrCodeCheckResult = "None";
  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  String userName;
  DeliveryPickerState(this.userName);
  //untuk autocomplete
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeSJController = TextEditingController();
  final TextEditingController _typeCustomerController = TextEditingController();

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
    fetchData();
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
        "SELECT * FROM sj_number "
            "WHERE surat_jalan = ? AND order_item = ? ", [widget.surat_jalan, barcodeScanCheck]);

    if (data.length > 0) {
      setState(() {
        barcodeValue = data[0]['order_item'].toString();
        qrCodeCheckResult.text = barcodeValue;
        qtyController.text = data[0]['ship_quantity'].toString();
        qtyCheckController.text = data[0]['ship_quantity'].toString();
      });
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
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuClass()),
                );
              },
            )
          ],
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
                                          controller: this._typeSJController,
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
                                              labelText: 'Search S/J')),
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
                                    this._typeSJController.text = suggestion;
                                    if (suggestion != true) {
                                      fetchDataSJ();
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
                                                this._typeCustomerController,
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.people),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(15.0),
                                                labelText: 'Search Customer')),
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
                                      this._typeCustomerController.text =
                                          suggestion;
                                      if (suggestion != true) {
                                        fetchDataCustomer();
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
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                        key: keys[2],
                                        color: Colors.teal,
                                        child: Text(
                                          'Check Item',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            qrCodeCheckResult.text = "";
                                            qtyController.text = "";
                                            qtyCheckController.text = "";
                                          });
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SimpleDialog(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0, right: 0.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.0,
                                                                    right:
                                                                        100.0),
                                                            child: Text(
                                                              "Checked Item",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20.0),
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon:
                                                              Icon(Icons.close),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  right: 5),
                                                          child: TextField(
                                                            controller:
                                                                qrCodeCheckResult,
                                                            decoration:
                                                                InputDecoration(
                                                              prefixIcon: Icon(
                                                                  Icons
                                                                      .receipt),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        25.0),
                                                                borderSide:
                                                                    new BorderSide(),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              labelText:
                                                                  'Item Number Scan',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                right: 10),
                                                        child: InkWell(
                                                          onTap: () {
                                                            //openScanner();
                                                            openScannerCheck();
                                                          },
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .barcode,
                                                            size: 45,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Text(
                                                      "QTY",
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0,
                                                        right: 10.0),
                                                    child: TextField(
                                                      controller:
                                                      qtyController,
                                                      style: new TextStyle(
                                                          fontSize: 14.0,
                                                          height: 1.0,
                                                          color: Colors.black),
                                                      decoration:
                                                          new InputDecoration(
                                                        prefixIcon: Icon(Icons
                                                            .shopping_basket),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  25.0),
                                                          borderSide:
                                                              new BorderSide(),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 14.0,
                                                                horizontal:
                                                                    15.0),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Text(
                                                      "QTY Check",
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0,
                                                        right: 10.0),
                                                    child: TextField(
                                                      controller:
                                                          qtyCheckController,
                                                      style: new TextStyle(
                                                          fontSize: 14.0,
                                                          height: 1.0,
                                                          color: Colors.black),
                                                      decoration:
                                                          new InputDecoration(
                                                        prefixIcon: Icon(Icons
                                                            .assignment_turned_in),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  25.0),
                                                          borderSide:
                                                              new BorderSide(),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 14.0,
                                                                horizontal:
                                                                    15.0),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10.0,
                                                            10.0,
                                                            10.0,
                                                            0),
                                                    child: RaisedButton(
                                                      color: Colors.blue,
                                                      child: Text(
                                                        "SIMPAN",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () async {
                                                        Database db = await widget.databaseHelper.database;
                                                        await db.rawQuery(
                                                            "UPDATE sj_number SET ship_quantity_check = ? "
                                                                "WHERE surat_jalan = ? AND order_item = ? ", [int.parse(qtyCheckController.text),widget.surat_jalan, qrCodeCheckResult.text]);
                                                        Navigator.pop(context, true);
                                                        fetchData();
                                                      },
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        }),
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
                            ],
                          ),
                          /*Row(
                            children: <Widget>[
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),*/
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
              3: FractionColumnWidth(.2),
              0: FractionColumnWidth(.1)
            }, children: [
              TableRow(
                children: [
                  Center(child: Text('#')),
                  Center(child: Text('Item Number')),
                  Center(child: Text('Qty')),
                  Center(child: Text('QTY Check')),
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
                      3: FractionColumnWidth(.2),
                      0: FractionColumnWidth(.1)
                    },
                    children: productData),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.only(top: 1, bottom: 7, left: 15, right: 15),
                    child: FormBuilder(
                      //key: this._formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 1),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      color: Colors.blue,
                                      onPressed: () async {
                                        if(await saveData()){
                                          Toast.show("Save Success", context, duration: Toast.LENGTH_LONG);
                                          Navigator.pop(context, true);
                                        }else{
                                          Toast.show("Please check all data.", context, duration: Toast.LENGTH_LONG);
                                        }
                                      },
                                      child: Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      ),
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
                              ),
                            ],
                          ),
                          /*Row(
                            children: <Widget>[
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            /*tambahan untuk detail table d/o number dari aldi */
            /*Expanded(
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
                      FormBuilderDropdown(
                        attribute: "type_truck",
                        decoration: InputDecoration(labelText: "Type Truck"),
                        validators: [FormBuilderValidators.required()],
                        items: [
                          [1, 'QD'],
                          [2, 'QDD'],
                          [3, 'Fuso']
                        ]
                            .map((item) => DropdownMenuItem(
                                value: item[1],
                                child: Text(item[1].toString())))
                            .toList(),
                      ),
                      FormBuilderTextField(
                        attribute: "Driver",
                        decoration: InputDecoration(labelText: "Driver"),
                        keyboardType: TextInputType.text,
                        /*validators: [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric()
                  ],*/
                      ),
                      FormBuilderDropdown(
                        attribute: "line_delivery",
                        decoration: InputDecoration(labelText: "Line Delivery"),
                        validators: [FormBuilderValidators.required()],
                        items: [
                          [1, 'Line 1'],
                          [2, 'Line 2'],
                          [3, 'Line 3']
                        ]
                            .map((item) => DropdownMenuItem(
                                value: item[1],
                                child: Text(item[1].toString())))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),*/

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
          ],
        ));
  }

  /*tambahan untuk query fetch detail table d/o number dari aldi */

  /*void fetchDataList() {
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
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['quantity'].toString())),
        ),

        /*Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['quantity'].toString())),
        ),*/

        Padding(
          padding: EdgeInsets.all(5),
          child: Center(
              child: InkWell(
            onTap: () {
              openScannerCheck();
            },
            child: Icon(
              FontAwesomeIcons.barcode,
              size: 30,
            ),
          )),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(
            child: Text(
              qrCodeCheckResult,
              style: TextStyle(
                fontSize: 12.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]));
    });
    setState(() {
      productData = rows;
    });
  }*/

  void fetchDataBarcode() async {
    //print(areaId);
    //final TextEditingController _typeSJController = TextEditingController();
    print(_typeSJController.text);
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery(
        "SELECT area_product_qty.area_id as areaid, product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE area_product_qty.area_id = ? AND product_code = ? AND quantity > 0",
        [_typeSJController.text, _typeCustomerController.text]);
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Topic"),
                          //digunakan untuk body dialog
                          content: Text("Dialog Content"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
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

  void fetchDataSJ() async {
    //print(areaId);
    //final TextEditingController _typeSJController = TextEditingController();
    print(_typeSJController.text);
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery(
        "SELECT area_product_qty.area_id as areaid, product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE area_product_qty.area_id = ? AND quantity > 0",
        [_typeSJController.text]);
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Topic"),
                          //digunakan untuk body dialog
                          content: Text("Dialog Content"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
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

  void fetchDataCustomer() async {
    //print(areaId);
    //final TextEditingController _typeSJController = TextEditingController();
    print(_typeCustomerController.text);
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery(
        "SELECT area_product_qty.area_id as areaid, product_code, product_description, quantity FROM area_product_qty "
        "LEFT JOIN product ON product.product_id = area_product_qty.product_id "
        "LEFT JOIN area ON area.area_id = area_product_qty.area_id "
        "LEFT JOIN warehouse ON warehouse.warehouse_id = area_product_qty.warehouse_id "
        "WHERE product_code = ? AND quantity > 0",
        [_typeCustomerController.text]);
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Topic"),
                          //digunakan untuk body dialog
                          content: Text("Dialog Content"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
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

  void fetchData() async {
    Database db = await widget.databaseHelper.database;
    final allRows = await db.rawQuery(
        "SELECT order_item, ship_quantity, ship_quantity_check FROM sj_number "
        "WHERE surat_jalan = ?", [widget.surat_jalan]);
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
          child: Text(row['order_item'] ?? ''),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['ship_quantity'].toString())),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Text(row['ship_quantity_check'].toString())),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Center(child: Icon((row['ship_quantity_check'] == 0 ? Icons.close : Icons.check))),
        ),
      ]));
    });
    setState(() {
      productData = rows;
    });
  }

  Future<bool> saveData() async {
    Database db = await widget.databaseHelper.database;
    final uncheckedData = await db.rawQuery(
        "SELECT order_item, ship_quantity, ship_quantity_check FROM sj_number "
            "WHERE surat_jalan = ? AND ship_quantity_check = 0 ", [widget.surat_jalan]);
    if(uncheckedData.length > 0){
      return false;
    }
    await db.rawQuery(
        "UPDATE sj_number SET delivery_sync = 0 "
            "WHERE surat_jalan = ? ", [widget.surat_jalan]);
    return true;
  }
}
