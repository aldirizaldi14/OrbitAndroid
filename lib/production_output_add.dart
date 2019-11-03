import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:random_string/random_string.dart';
import 'package:unified_process/model/area_product_qty_model.dart';
import 'helper/database_helper.dart';
import 'model/production_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class ProductionOutputAddClass extends StatefulWidget {
  ProductionOutputAddClass({ Key key}) : super (key: key);
  final String title = 'Add Production Output';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductionOutputAddState createState() => ProductionOutputAddState();
}

class ProductionOutputAddState extends State<ProductionOutputAddClass>{
  TextEditingController productController = TextEditingController(text: 'Scan product');
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  int product_id = 0;
  String barcodeValue = '';
  List lineData = [];

  @override
  initState() {
    super.initState();
    fetchLineData();
  }

  Future<void> openScanner() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT product_id, product_code "
        "FROM product "
        "WHERE (product_code = ? OR product_code_alt = ?) AND product_deleted_at IS NULL", [barcodeScanRes,barcodeScanRes]
    );
    if(data.length > 0){
      setState(() {
        product_id = data[0]['product_id'];
        barcodeValue = data[0]['product_code'];
        productController.text = barcodeValue;
      });
    } else {
      Toast.show("Invalid Product", context);
    }
  }

  void saveData() async{
    final formData = formKey.currentState.value;
    final dTime = new DateTime.now();
    Database db = await widget.databaseHelper.database;

    ProductionModel production = ProductionModel.instance;
    production.production_product_id = product_id;
    production.production_batch = formData['batch'];
    production.production_line_id = formData['line_id'];
    production.production_shift = formData['shift'];
    production.production_remark = formData['remark'];
    production.production_qty = int.parse(formData['quantity']);
    production.production_time = new DateFormat("yyyy-MM-dd HH:mm:ss").format(dTime);
    production.production_code = randomAlpha(3) + new DateFormat("ddHHmm").format(dTime);
    production.production_sync = 0;
    int production_id = await widget.databaseHelper.insert(production.tableName, production.toMap());
    if(production_id > 0){
      // check quantity in production store exist or not
      final check = await db.rawQuery("SELECT * FROM area_product_qty "
          "WHERE warehouse_id = 1 AND product_id = ? ", [product_id]);
      if(check.length == 0){
        await db.rawInsert('INSERT INTO area_product_qty(warehouse_id, area_id, product_id, quantity) VALUES(1, 0, ?, ?)', [product_id, int.parse(formData['quantity'])]);
      }else{
        AreaProductQtyModel d = AreaProductQtyModel.fromDb(check[0]);
        int qty = d.quantity + int.parse(formData['quantity']);
        await db.rawQuery("UPDATE area_product_qty SET quantity = ? "
            "WHERE warehouse_id = 1 AND product_id = ? ", [qty, product_id]);
      }
      Navigator.pop(context);
    }
  }

  void fetchLineData() async {
    Database db = await widget.databaseHelper.database;
    final data = await db.rawQuery("SELECT line_id, line_name "
        "FROM line WHERE line_deleted_at IS NULL "
        "ORDER BY line_name ASC"
    );
    setState(() {
      lineData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(5),
                child: FormBuilder(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FormBuilderTextField(
                                attribute: "product_id",
                                controller: productController,
                                decoration: InputDecoration(labelText: "Product"),
                                readOnly: true,
                                validators: [
                                  (val){
                                    if(val == 'Scan product'){
                                      productController.text = 'Scan product';
                                      return '-';
                                    }
                                  },
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                openScanner();
                              },
                              child: Icon(FontAwesomeIcons.barcode, size: 65,),
                            )
                          ],
                        ),
                        FormBuilderDropdown(
                          attribute: "line_id",
                          decoration: InputDecoration(labelText: "Line"),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                          items: lineData.length == 0 ? [] : lineData.map((item) => DropdownMenuItem(
                              value: item['line_id'],
                              child: Text(item['line_name'].toString())
                          )).toList(),
                        ),
                        FormBuilderDropdown(
                          attribute: "shift",
                          decoration: InputDecoration(labelText: "Shift"),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                          items: [[1, 'A'], [2, 'B'], [3, 'C']]
                              .map((item) => DropdownMenuItem(
                              value: item[1],
                              child: Text(item[1].toString())
                          )).toList(),
                        ),
                        FormBuilderDropdown(
                          attribute: "batch",
                          decoration: InputDecoration(labelText: "Lot"),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                          items: [[1, 'Lot 1'],[2, 'Lot 2'],[3, 'Lot 3'],[4, 'Lot 4'],[5, 'Lot 5']]
                              .map((item) => DropdownMenuItem(
                              value: item[1],
                              child: Text(item[1].toString())
                          )).toList(),
                        ),
                        FormBuilderTextField(
                          attribute: "quantity",
                          decoration: InputDecoration(labelText: "Quantity"),
                          keyboardType: TextInputType.number,
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric()
                          ],
                        ),
                        FormBuilderDropdown(
                          attribute: "remark",
                          decoration: InputDecoration(labelText: "Remark"),
                          items: ['', '99', '97', '93']
                              .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.toString())
                          )).toList(),
                        ),
                      ],
                    )
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  if(formKey.currentState.saveAndValidate()) {
                    print(formKey.currentState.value);
                    saveData();
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