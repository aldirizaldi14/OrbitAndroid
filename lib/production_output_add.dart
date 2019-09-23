import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'helper/database_helper.dart';
import 'model/production.dart';

class ProductionOutputAddClass extends StatefulWidget {
  ProductionOutputAddClass({ Key key}) : super (key: key);
  final String title = 'Production Output Add';
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  ProductionOutputAddState createState() => ProductionOutputAddState();
}

class ProductionOutputAddState extends State<ProductionOutputAddClass>{
  TextEditingController productController = TextEditingController();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  String barcodeValue = '';
  Future<void> initPlatformState() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      barcodeValue = barcodeScanRes;
      productController.text = barcodeValue;
    });
  }

  void saveData() async{
    Production production = Production(1, '', '', 1);
    production = Production.random();
    int test = await widget.databaseHelper.insert(production.tableName, production.toMap());
    print(test);
    if(test > 0){
      Navigator.pop(context);
    }
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
                                decoration: InputDecoration(labelText: "Product", fillColor: Colors.black12, filled: true),
                                readOnly: true,
                                validators: [
                                  (val){
                                    if((val == '') || (val == 'Please Scan Product')){
                                      productController.text = 'Please Scan Product';
                                      return '-';
                                    }
                                  },
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                initPlatformState();
                              },
                              child: Icon(FontAwesomeIcons.barcode, size: 50,),
                            )
                          ],
                        ),
                        FormBuilderDropdown(
                          attribute: "line_id",
                          decoration: InputDecoration(labelText: "Line"),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                          items: ['Line 1', 'Line 2', 'Line 3']
                              .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.toString())
                          )).toList(),
                        ),
                        FormBuilderDropdown(
                          attribute: "shift",
                          decoration: InputDecoration(labelText: "Shift"),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                          items: ['A', 'B', 'C']
                              .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.toString())
                          )).toList(),
                        ),
                        FormBuilderDropdown(
                          attribute: "batch",
                          decoration: InputDecoration(labelText: "Batch Time"),
                          validators: [
                            FormBuilderValidators.required()
                          ],
                          items: ['Hour to 1', 'Hour to 2', 'Hour to 3', 'Hour to 4', 'Hour to 5']
                              .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.toString())
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