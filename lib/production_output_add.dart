import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'helper/database_helper.dart';
import 'model/production_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class ProductionOutputAddClass extends StatefulWidget {
  ProductionOutputAddClass({ Key key}) : super (key: key);
  final String title = 'Production Output Add';
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
        "WHERE product_code = ? AND product_deleted_at IS NULL", [barcodeScanRes]
    );
    if(data.length > 0){
      setState(() {
        product_id = data[0]['product_id'];
        barcodeValue = barcodeScanRes;
        productController.text = barcodeValue;
      });
    } else {
      Toast.show("Product invalid", context);
    }
  }

  void saveData() async{
    final formData = formKey.currentState.value;
    ProductionModel production = ProductionModel.instance;
    production.production_product_id = product_id;
    production.production_batch = formData['batch'];
    production.production_line_id = formData['line_id'];
    production.production_shift = formData['shift'];
    production.production_qty = int.parse(formData['quantity']);
    production.production_time = new DateFormat("yyyy-MM-dd hh:mm:ss").format(new DateTime.now());
    int production_id = await widget.databaseHelper.insert(production.tableName, production.toMap());
    if(production_id > 0){
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
                          decoration: InputDecoration(labelText: "Batch Time"),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                          items: [[1, 'Hour to 1'],[2, 'Hour to 2'],[3, 'Hour to 3'],[4, 'Hour to 4'],[5, 'Hour to 5']]
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