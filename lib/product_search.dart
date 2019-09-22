import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductSearch extends StatefulWidget {
  ProductSearch({ Key key}) : super (key: key);
  final String title = 'Product Search';

  @override
  ProductSearchState createState() => ProductSearchState();
}

class ProductSearchState extends State<ProductSearch> {
  String productCode = '';
  String description = '';
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
      productCode = barcodeScanRes;
      description = 'Description of ' + productCode;
    });
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
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  child: Icon(FontAwesomeIcons.barcode, color: Colors.white,),
                  onPressed: (){
                    setState(() {
                      productCode = 'E123A';
                      description = 'Description of ' + productCode;
                    });
                  },
                ),
              ),
              Text(productCode, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Text(description, style: TextStyle(fontSize: 12),),
              Table(
                border: TableBorder.all(color: Colors.black),
                columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.2), 3: FractionColumnWidth(.2)},
                children: [
                  TableRow(
                      children: [
                        Text('#'),
                        Text('Warehouse'),
                        Text('Pallet'),
                        Text('Qty'),
                      ]
                  ),
          ]
            ),
              Expanded(
                child: SingleChildScrollView(
                child: Table(
                border: TableBorder.all(color: Colors.black),
                columnWidths: {0: FractionColumnWidth(.1), 2: FractionColumnWidth(.2), 3: FractionColumnWidth(.2)},
                children: [
                  TableRow(
                      children: [
                        Text('1'),
                        Text('A'),
                        Text('2'),
                        Text('10'),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text('1'),
                        Text('A'),
                        Text('2'),
                        Text('10'),
                      ]
                  ),
                ],
              ),
              ),
              )
            ],
          ),
        )
    );
  }
}